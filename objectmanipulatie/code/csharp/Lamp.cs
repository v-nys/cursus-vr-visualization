using Godot;

public partial class Lamp : Node
{
    [Export] public OmniLight3D Light { get; set; }

    public override void _Ready()
    {
        GetParent().Connect("action_pressed",
            Callable.From<Node3D>(OnActionPressed));
    }

    private void OnActionPressed(Node3D pickable)
    {
        Light.Visible = !Light.Visible;
    }
}
