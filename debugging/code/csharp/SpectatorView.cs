using Godot;

// Koppel aan de Control-root van de spectator-scène.
public partial class SpectatorView : Control
{
    [Export] public SubViewport Hmd { get; set; }
    [Export] public SubViewport FirstPersonViewport { get; set; }
    [Export] public XRCamera3D XrCamera { get; set; }
    [Export] public Camera3D ThirdPersonCamera { get; set; }
    [Export] public Camera3D InsetCamera { get; set; }
    [Export] public HSlider FovSlider { get; set; }

    private const uint WorldLayer = 1u << 0;
    private const uint HmdLayer = 1u << 1;
    private const uint SpectatorLayer = 1u << 2;
    private const uint FirstPersonLayer = 1u << 3;

    public override void _Ready()
    {
        if (Hmd == null || FirstPersonViewport == null || XrCamera == null
            || ThirdPersonCamera == null || InsetCamera == null || FovSlider == null)
        {
            GD.PushError("Koppel alle spectator-referenties in de Inspector.");
            return;
        }
        Viewport desktop = GetViewport();
        desktop.UseXR = false;
        // De bestaande Main-scène schakelt Hmd.UseXR in na OpenXR-initialisatie.
        World3D sharedWorld = desktop.FindWorld3D();
        Hmd.OwnWorld3D = false;
        FirstPersonViewport.OwnWorld3D = false;
        Hmd.World3D = sharedWorld;
        FirstPersonViewport.World3D = sharedWorld;
        FirstPersonViewport.UseXR = false;
        FirstPersonViewport.Size = new Vector2I(300, 300);
        FirstPersonViewport.RenderTargetUpdateMode = SubViewport.UpdateMode.Always;
        XrCamera.CullMask = WorldLayer | HmdLayer;
        ThirdPersonCamera.CullMask = WorldLayer | SpectatorLayer;
        InsetCamera.CullMask = WorldLayer | FirstPersonLayer;
        XrCamera.MakeCurrent();
        ThirdPersonCamera.MakeCurrent();
        InsetCamera.MakeCurrent();
        FovSlider.MinValue = 60;
        FovSlider.MaxValue = 120;
        FovSlider.Step = 1;
        FovSlider.SetValueNoSignal(InsetCamera.Fov);
        FovSlider.ValueChanged += OnFovChanged;
    }

    public override void _ExitTree()
    {
        if (GodotObject.IsInstanceValid(FovSlider)) FovSlider.ValueChanged -= OnFovChanged;
    }

    private void OnFovChanged(double value) => InsetCamera.Fov = (float)value;
}
