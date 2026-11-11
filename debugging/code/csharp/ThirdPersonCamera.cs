using Godot;

// Gebaseerd op Bastiaan Olij, tutorialbranch spectator_view (MIT).
public partial class ThirdPersonCamera : Camera3D
{
    [Export] public Node3D Target { get; set; }

    public override void _Ready() => ProcessPriority = 10;

    public override void _Process(double delta)
    {
        if (!GodotObject.IsInstanceValid(Target)) return;
        Vector3 direction = Target.GlobalPosition - GlobalPosition;
        if (direction.LengthSquared() < 0.000001f) return;
        Vector3 up = Vector3.Up;
        if (Mathf.Abs(direction.Normalized().Dot(up)) > 0.999f)
            up = Vector3.Forward;
        LookAt(Target.GlobalPosition, up);
    }
}
