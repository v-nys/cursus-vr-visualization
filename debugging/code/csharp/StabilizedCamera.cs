using Godot;

// Gebaseerd op Bastiaan Olij, tutorialbranch spectator_view (MIT).
public partial class StabilizedCamera : Camera3D
{
    [Export] public XRCamera3D XrCamera { get; set; }
    [Export(PropertyHint.Range, "0.01,1.0,0.01,suffix:s")]
    public float SmoothDelay { get; set; } = 0.1f;

    private Transform3D _previous = Transform3D.Identity;
    private bool _initialized;

    public override void _Ready()
    {
        ProcessPriority = 10;
        ResetSmoothing();
    }

    public void ResetSmoothing()
    {
        _initialized = false;
        if (GodotObject.IsInstanceValid(XrCamera))
        {
            _previous = WithoutRoll(XrCamera.Transform);
            _initialized = true;
        }
    }

    private static Transform3D WithoutRoll(Transform3D value)
    {
        Vector3 forward = -value.Basis.Z.Normalized();
        value.Basis = Mathf.Abs(forward.Dot(Vector3.Up)) < 0.999f
            ? Basis.LookingAt(forward, Vector3.Up)
            : value.Basis.Orthonormalized();
        return value;
    }

    public override void _Process(double delta)
    {
        if (!GodotObject.IsInstanceValid(XrCamera)) return;
        if (XrCamera.GetParent() is not Node3D origin) return;
        if (!_initialized) ResetSmoothing();
        Transform3D target = WithoutRoll(XrCamera.Transform);
        float weight = 1.0f - Mathf.Exp(-(float)delta / Mathf.Max(SmoothDelay, 0.001f));
        _previous.Basis = _previous.Basis.Slerp(target.Basis, weight);
        _previous.Origin = _previous.Origin.Lerp(target.Origin, weight);
        GlobalTransform = origin.GlobalTransform * _previous;
    }
}
