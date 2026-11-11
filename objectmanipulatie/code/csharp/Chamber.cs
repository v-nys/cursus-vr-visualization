using Godot;

public partial class Chamber : Node
{
    public enum ChamberState { Empty, Live, Spent }
    [Export] public Node3D MagazineZone { get; set; }
    [Export] public Marker3D Muzzle { get; set; }
    [Export] public PackedScene ProjectileScene { get; set; }
    [Export] public float Speed { get; set; } = 8.0f;
    public ChamberState State { get; private set; } = ChamberState.Empty;

    public override void _Ready()
    {
        GetParent().Connect("action_pressed", Callable.From<Node3D>(OnAction));
    }

    public void Cycle()
    {
        State = ChamberState.Empty;
        // De addon is GDScript: behoud zijn exacte propertynaam.
        var item = MagazineZone.Get("picked_up_object").AsGodotObject() as Node;
        if (!GodotObject.IsInstanceValid(item)) return;
        var magazine = item.GetNodeOrNull<Magazine>("Magazine");
        if (magazine != null && magazine.TakeRound()) State = ChamberState.Live;
    }

    private void OnAction(Node3D pickable)
    {
        if (State != ChamberState.Live)
        {
            GD.Print("Klik: geen geladen patroon");
            return;
        }
        if (ProjectileScene == null) return;
        var instance = ProjectileScene.Instantiate();
        if (instance is not RigidBody3D projectile)
        {
            instance.QueueFree();
            GD.PushError("Projectile heeft geen RigidBody3D-root");
            return;
        }
        GetTree().CurrentScene.AddChild(projectile);
        projectile.GlobalTransform = Muzzle.GlobalTransform;
        projectile.LinearVelocity = -Muzzle.GlobalBasis.Z.Normalized() * Speed;
        State = ChamberState.Spent;
    }
}
