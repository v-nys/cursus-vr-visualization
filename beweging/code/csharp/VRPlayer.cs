using Godot;

// Alternatief voor vr_player.gd; koppel slechts één van beide aan CharacterBody3D.
public partial class VRPlayer : CharacterBody3D
{
    [Export] public XROrigin3D Origin { get; set; }
    [Export] public XRCamera3D Camera { get; set; }
    [Export] public XRController3D MovementController { get; set; }
    [Export] public XRController3D TurnController { get; set; }
    [Export] public CollisionShape3D BodyCollision { get; set; }
    [Export] public MeshInstance3D FadeMesh { get; set; }
    [Export] public MeshInstance3D VignetteMesh { get; set; }
    [Export] public RayCast3D FloorRay { get; set; }
    [Export] public Vector2 MaxSpeed { get; set; } = new(1.5f, 2.0f);
    [Export] public float Acceleration { get; set; } = 6.0f;
    [Export] public float TurnSpeedDegrees { get; set; } = 45.0f;
    [Export] public float SnapDegrees { get; set; } = 30.0f;
    [Export] public float VignetteStrength { get; set; } = 0.3f;
    [Export] public float FadeStart { get; set; } = 0.2f;
    [Export] public float FadeDistance { get; set; } = 0.2f;
    [Export] public float HeadRadius { get; set; } = 0.15f;
    [Export] public float TargetHeadHeight { get; set; } = 1.6f;
    [Export] public float BodyRadius { get; set; } = 0.3f;
    [Export] public float HeadMargin { get; set; } = 0.2f;
    [Export] public bool UseStairSupport { get; set; }
    [Export] public float UpperBodyHeight { get; set; } = 1.0f;
    [Export] public float Kp { get; set; } = 0.8f;
    [Export] public float Ki { get; set; } = 0.1f;
    [Export] public float Kd { get; set; } = 0.2f;
    [Export] public float IntegralLimit { get; set; } = 1.0f;

    private CapsuleShape3D _capsule;
    private readonly PhysicsShapeQueryParameters3D _headQuery = new();
    private ShaderMaterial _fadeMaterial;
    private ShaderMaterial _vignetteMaterial;
    private float _turnAccumulator;
    private float _integral;
    private float _lastValue;
    private bool _hasLastValue;

    public override void _Ready()
    {
        if (Origin == null || Camera == null || BodyCollision?.Shape is not CapsuleShape3D source)
        {
            GD.PushError("Koppel Origin, Camera en Body Collision met een CapsuleShape3D.");
            SetPhysicsProcess(false);
            return;
        }
        _capsule = (CapsuleShape3D)source.Duplicate();
        BodyCollision.Shape = _capsule;
        _headQuery.Shape = new SphereShape3D { Radius = HeadRadius };
        _headQuery.Exclude = new Godot.Collections.Array<Rid> { GetRid() };
        _headQuery.CollisionMask = CollisionMask;
        _fadeMaterial = UniqueMaterial(FadeMesh);
        _vignetteMaterial = UniqueMaterial(VignetteMesh);
        if (FloorRay != null)
        {
            FloorRay.AddException(this);
            FloorRay.CollisionMask = CollisionMask;
            FloorRay.Enabled = true;
        }
        if (XRServer.FindInterface("OpenXR") is OpenXRInterface xr)
            xr.PoseRecentered += OnPoseRecentered;
    }

    public override void _ExitTree()
    {
        if (XRServer.FindInterface("OpenXR") is OpenXRInterface xr)
            xr.PoseRecentered -= OnPoseRecentered;
    }

    private static ShaderMaterial UniqueMaterial(MeshInstance3D mesh)
    {
        if (mesh?.MaterialOverride is not ShaderMaterial source) return null;
        var material = (ShaderMaterial)source.Duplicate();
        mesh.MaterialOverride = material;
        return material;
    }

    // Roep aan na bevestiging door de speler, wanneer tracking beschikbaar is.
    public bool CalibrateHeight()
    {
        if (XRServer.GetTracker("head") is not XRPositionalTracker tracker) return false;
        var pose = tracker.GetPose("default");
        if (pose == null || !pose.HasTrackingData) return false;
        float offset = TargetHeadHeight - pose.GetAdjustedTransform().Origin.Y;
        Origin.Position = Origin.Position with { Y = offset };
        return true;
    }

    private void OnPoseRecentered() => Callable.From(() => { CalibrateHeight(); }).CallDeferred();

    public override void _PhysicsProcess(double delta)
    {
        float dt = (float)delta;
        UpdateBodyShape();
        float separation = FollowPhysicalMovement();
        bool blocked = HeadIsBlocked();
        bool restricted = blocked || separation > FadeStart;
        float turnInput = TurnController != null && TurnController.GetIsActive()
            ? -TurnController.GetVector2("movement").X : 0.0f;
        if (restricted) turnInput = 0.0f;
        ApplyTurn(turnInput, dt);
        ApplyMovement(dt, restricted);
        Velocity += GetGravity() * dt;
        ApplyStairSupport(dt);
        MoveAndSlide();
        float fade = Mathf.Clamp((separation - FadeStart) / Mathf.Max(FadeDistance, 0.001f), 0, 1);
        SetEffects(blocked ? 1.0f : fade, turnInput);
    }

    private void UpdateBodyShape()
    {
        float headY = ToLocal(Camera.GlobalPosition).Y;
        float top = Mathf.Max(headY + HeadMargin, 2.0f * BodyRadius);
        float height = UseStairSupport ? Mathf.Max(UpperBodyHeight, 2.0f * BodyRadius) : top;
        _capsule.Radius = Mathf.Min(BodyRadius, _capsule.Height * 0.5f);
        _capsule.Height = height;
        _capsule.Radius = BodyRadius;
        BodyCollision.Position = BodyCollision.Position with { Y = top - height * 0.5f };
        if (FloorRay != null)
        {
            float rayY = Mathf.Max(top - height, 0.01f);
            FloorRay.Position = FloorRay.Position with { Y = rayY };
            FloorRay.TargetPosition = new Vector3(0, -rayY - 0.1f, 0);
        }
    }

    private float FollowPhysicalMovement()
    {
        Transform3D savedOrigin = Origin.GlobalTransform;
        Vector3 localHead = ToLocal(Camera.GlobalPosition);
        localHead.Y = 0;
        Vector3 target = ToGlobal(localHead);
        MoveAndCollide(target - GlobalPosition);
        Vector3 forward = -Camera.GlobalBasis.Z;
        forward.Y = 0;
        if (forward.LengthSquared() > 0.000001f)
            GlobalBasis = Basis.LookingAt(forward.Normalized(), Vector3.Up);
        Origin.GlobalTransform = savedOrigin;
        Vector3 remainder = target - GlobalPosition;
        remainder.Y = 0;
        return remainder.Length();
    }

    private void ApplyMovement(float dt, bool restricted)
    {
        Vector2 stick = !restricted && MovementController != null && MovementController.GetIsActive()
            ? MovementController.GetVector2("movement").LimitLength() : Vector2.Zero;
        Vector3 target = GlobalBasis * new Vector3(stick.X * MaxSpeed.X, 0, -stick.Y * MaxSpeed.Y);
        float weight = 1.0f - Mathf.Exp(-Acceleration * dt);
        Vector3 v = Velocity;
        v.X = restricted ? 0 : Mathf.Lerp(v.X, target.X, weight);
        v.Z = restricted ? 0 : Mathf.Lerp(v.Z, target.Z, weight);
        Velocity = v;
    }

    private void ApplyTurn(float input, float dt)
    {
        if (Mathf.Abs(input) < 0.15f) { _turnAccumulator = 0; return; }
        float angle = input * Mathf.DegToRad(TurnSpeedDegrees) * dt;
        if (SnapDegrees > 0)
        {
            _turnAccumulator += angle;
            float step = Mathf.DegToRad(SnapDegrees);
            if (Mathf.Abs(_turnAccumulator) < step) return;
            angle = Mathf.Sign(_turnAccumulator) * step;
            _turnAccumulator -= angle;
        }
        Vector3 pivot = Camera.GlobalPosition;
        pivot.Y = GlobalPosition.Y;
        Basis yaw = new(Vector3.Up, angle);
        GlobalTransform = new Transform3D(yaw * GlobalBasis, pivot + yaw * (GlobalPosition - pivot));
    }

    private bool HeadIsBlocked()
    {
        var state = GetWorld3D().DirectSpaceState;
        Vector3 localHead = ToLocal(Camera.GlobalPosition);
        Vector3 start = ToGlobal(new Vector3(0, localHead.Y, 0));
        _headQuery.Transform = new Transform3D(Basis.Identity, start);
        _headQuery.Motion = Vector3.Zero;
        if (state.IntersectShape(_headQuery, 1).Count > 0) return true;
        _headQuery.Motion = Camera.GlobalPosition - start;
        float[] fractions = state.CastMotion(_headQuery);
        if (fractions.Length > 0 && fractions[0] < 1.0f) return true;
        _headQuery.Transform = new Transform3D(Basis.Identity, Camera.GlobalPosition);
        _headQuery.Motion = Vector3.Zero;
        return state.IntersectShape(_headQuery, 1).Count > 0;
    }

    private void ApplyStairSupport(float dt)
    {
        if (!UseStairSupport || FloorRay == null) { ResetPid(); return; }
        FloorRay.ForceRaycastUpdate();
        if (!FloorRay.IsColliding() || FloorRay.GetCollisionNormal().Dot(Vector3.Up) < Mathf.Cos(FloorMaxAngle))
        { ResetPid(); return; }
        float floorY = ToLocal(FloorRay.GetCollisionPoint()).Y;
        float error = floorY;
        _integral = Mathf.Clamp(_integral + error * dt, -IntegralLimit, IntegralLimit);
        float derivative = _hasLastValue ? (floorY - _lastValue) / dt : 0;
        _lastValue = floorY;
        _hasLastValue = true;
        Velocity += GlobalBasis.Y * (Kp * error + Ki * _integral + Kd * derivative);
    }

    private void ResetPid() { _integral = 0; _hasLastValue = false; }

    private void SetEffects(float fade, float turnInput)
    {
        if (_fadeMaterial != null)
        {
            _fadeMaterial.SetShaderParameter("alpha", fade);
            FadeMesh.Visible = fade > 0;
        }
        if (_vignetteMaterial != null)
        {
            float radius = Mathf.Clamp(1.0f - Mathf.Abs(turnInput) * VignetteStrength, 0, 1);
            _vignetteMaterial.SetShaderParameter("radius", radius * Mathf.Sqrt(2.0f));
            VignetteMesh.Visible = radius < 1.0f;
        }
    }
}
