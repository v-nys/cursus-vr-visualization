using Godot;

public partial class Slide : Node
{
    [Export] public Node3D Pivot { get; set; }
    [Export] public Node3D Visual { get; set; }
    [Export] public Node3D Handle { get; set; }
    [Export] public Chamber Chamber { get; set; }
    [Export] public float Travel { get; set; } = 0.075f;
    private Vector3 _visualRest;
    private Transform3D _handleRest;
    private bool _latched;

    public override void _Ready()
    {
        _visualRest = Visual.Position;
        _handleRest = Handle.Transform;
    }

    public override void _PhysicsProcess(double delta)
    {
        if (!Handle.Call("is_picked_up").AsBool())
        {
            Visual.Position = _visualRest;
            Handle.Transform = _handleRest;
            _latched = false;
            return;
        }
        var local = Pivot.ToLocal(Handle.GlobalPosition);
        var parent = (Node3D)Handle.GetParent();
        var rest = Pivot.ToLocal(parent.ToGlobal(_handleRest.Origin));
        float pull = Mathf.Clamp(local.Z - rest.Z, 0.0f, Travel);
        Visual.Position = _visualRest + new Vector3(0, 0, pull);
        if (pull >= Travel * 0.95f && !_latched)
        {
            _latched = true;
            Chamber.Cycle();
        }
    }
}
