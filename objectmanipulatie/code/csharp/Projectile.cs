using Godot;

public partial class Projectile : RigidBody3D
{
    public override void _Ready()
    {
        GetTree().CreateTimer(3.0).Timeout += QueueFree;
    }
}
