class_name VRPlayer
extends CharacterBody3D

# Godot 4.5. Houd het lichaam rechtop en gebruik schaal (1, 1, 1).
@export var origin: XROrigin3D
@export var camera: XRCamera3D
@export var movement_controller: XRController3D
@export var turn_controller: XRController3D
@export var body_collision: CollisionShape3D
@export var fade_mesh: MeshInstance3D
@export var vignette_mesh: MeshInstance3D
@export var floor_ray: RayCast3D

@export var max_speed := Vector2(1.5, 2.0) # zijwaarts, voorwaarts in m/s
@export var acceleration: float = 6.0
@export var turn_speed_degrees: float = 45.0
@export var snap_degrees: float = 30.0 # 0 = vloeiend draaien
@export var vignette_strength: float = 0.3
@export var fade_start: float = 0.2
@export var fade_distance: float = 0.2
@export var head_radius: float = 0.15
@export var target_head_height: float = 1.6
@export var body_radius: float = 0.3
@export var head_margin: float = 0.2
@export var use_stair_support: bool = false
@export var upper_body_height: float = 1.0
@export var kp: float = 0.8
@export var ki: float = 0.1
@export var kd: float = 0.2
@export var integral_limit: float = 1.0

var _capsule: CapsuleShape3D
var _head_query := PhysicsShapeQueryParameters3D.new()
var _fade_material: ShaderMaterial
var _vignette_material: ShaderMaterial
var _turn_accumulator: float = 0.0
var _height_offset: float = 0.0
var _integral: float = 0.0
var _last_value: float = 0.0
var _has_last_value: bool = false

func _ready() -> void:
    if not origin or not camera or not body_collision:
        push_error("Koppel Origin, Camera en Body Collision in de Inspector.")
        set_physics_process(false)
        return
    var source := body_collision.shape as CapsuleShape3D
    if not source:
        push_error("Body Collision moet een CapsuleShape3D bevatten.")
        set_physics_process(false)
        return
    _capsule = source.duplicate() as CapsuleShape3D
    body_collision.shape = _capsule
    var sphere := SphereShape3D.new()
    sphere.radius = head_radius
    _head_query.shape = sphere
    _head_query.exclude = [get_rid()]
    _head_query.collision_mask = collision_mask
    _fade_material = _unique_material(fade_mesh)
    _vignette_material = _unique_material(vignette_mesh)
    if floor_ray:
        floor_ray.add_exception(self)
        floor_ray.collision_mask = collision_mask
        floor_ray.enabled = true
    var xr := XRServer.find_interface("OpenXR") as OpenXRInterface
    if xr:
        xr.pose_recentered.connect(_on_pose_recentered)

func _unique_material(mesh: MeshInstance3D) -> ShaderMaterial:
    if not mesh or not mesh.material_override is ShaderMaterial:
        return null
    var material := mesh.material_override.duplicate() as ShaderMaterial
    mesh.material_override = material
    return material

# Roep dit aan wanneer de speler in het startscherm bevestigt klaar te zijn.
# Herhaal niet elke tick: anders wordt fysiek bukken ongedaan gemaakt.
func calibrate_height() -> bool:
    var tracker := XRServer.get_tracker("head") as XRPositionalTracker
    if not tracker:
        return false
    var pose := tracker.get_pose("default")
    if not pose or not pose.has_tracking_data:
        return false
    _height_offset = target_head_height - pose.get_adjusted_transform().origin.y
    var p := origin.position
    p.y = _height_offset
    origin.position = p
    return true

func _on_pose_recentered() -> void:
    # Geef de runtime tijd om de aangepaste pose door te geven.
    call_deferred("calibrate_height")

func _physics_process(delta: float) -> void:
    _update_body_shape()
    var separation := _follow_physical_movement()
    var blocked := _head_is_blocked()
    var restricted := blocked or separation > fade_start
    var turn_input := 0.0
    if turn_controller and turn_controller.get_is_active():
        turn_input = -turn_controller.get_vector2("movement").x
    if restricted:
        turn_input = 0.0
    _apply_turn(turn_input, delta)
    _apply_movement(delta, restricted)
    velocity += get_gravity() * delta
    _apply_stair_support(delta)
    move_and_slide() # velocity is m/s: hier niet nog eens met delta vermenigvuldigen.
    var fade := clampf((separation - fade_start) / maxf(fade_distance, 0.001), 0.0, 1.0)
    _set_effects(1.0 if blocked else fade, turn_input)

func _update_body_shape() -> void:
    var head_y := to_local(camera.global_position).y
    var top := maxf(head_y + head_margin, 2.0 * body_radius)
    var height := top
    if use_stair_support:
        height = maxf(upper_body_height, 2.0 * body_radius)
    # Eerst verkleinen van de radius voorkomt tussentijdse ongeldige dimensies.
    _capsule.radius = minf(body_radius, _capsule.height * 0.5)
    _capsule.height = height
    _capsule.radius = body_radius
    var p := body_collision.position
    p.y = top - height * 0.5
    body_collision.position = p
    if floor_ray:
        var ray_p := floor_ray.position
        ray_p.y = maxf(top - height, 0.01)
        floor_ray.position = ray_p
        floor_ray.target_position = Vector3(0.0, -ray_p.y - 0.1, 0.0)

func _follow_physical_movement() -> float:
    var saved_origin := origin.global_transform
    var local_head := to_local(camera.global_position)
    local_head.y = 0.0
    var target := to_global(local_head)
    move_and_collide(target - global_position)
    var forward := -camera.global_basis.z
    forward.y = 0.0
    if forward.length_squared() > 0.000001:
        global_basis = Basis.looking_at(forward.normalized(), Vector3.UP)
    # Alleen fysieke beweging: behoud de trackingruimte in wereldcoördinaten.
    origin.global_transform = saved_origin
    var remainder := target - global_position
    remainder.y = 0.0
    return remainder.length()

func _apply_movement(delta: float, restricted: bool) -> void:
    var stick := Vector2.ZERO
    if not restricted and movement_controller and movement_controller.get_is_active():
        stick = movement_controller.get_vector2("movement").limit_length()
    # OpenXR-stick naar voren is +Y; Godot-vooruit is -Z.
    var target := global_basis * Vector3(stick.x * max_speed.x, 0.0, -stick.y * max_speed.y)
    var weight := 1.0 - exp(-acceleration * delta)
    if restricted:
        # Geen restbeweging door interpolatie wanneer het hoofd in een muur zit.
        velocity.x = 0.0
        velocity.z = 0.0
    else:
        velocity.x = lerpf(velocity.x, target.x, weight)
        velocity.z = lerpf(velocity.z, target.z, weight)

func _apply_turn(input: float, delta: float) -> void:
    if absf(input) < 0.15:
        _turn_accumulator = 0.0
        return
    var angle := input * deg_to_rad(turn_speed_degrees) * delta
    if snap_degrees > 0.0:
        _turn_accumulator += angle
        var step := deg_to_rad(snap_degrees)
        if absf(_turn_accumulator) < step:
            return
        angle = signf(_turn_accumulator) * step
        _turn_accumulator -= angle
    # Draai om het punt onder het hoofd, ook als lichaam en hoofd iets afwijken.
    var pivot := camera.global_position
    pivot.y = global_position.y
    var yaw := Basis(Vector3.UP, angle)
    global_transform = Transform3D(yaw * global_basis, pivot + yaw * (global_position - pivot))

func _head_is_blocked() -> bool:
    var state := get_world_3d().direct_space_state
    var local_head := to_local(camera.global_position)
    var start := to_global(Vector3(0.0, local_head.y, 0.0))
    _head_query.transform = Transform3D(Basis.IDENTITY, start)
    _head_query.motion = Vector3.ZERO
    if not state.intersect_shape(_head_query, 1).is_empty():
        return true
    _head_query.motion = camera.global_position - start
    var fractions := state.cast_motion(_head_query)
    if not fractions.is_empty() and fractions[0] < 1.0:
        return true
    # cast_motion negeert shapes waarmee de query al overlapt: controleer eindpunt ook.
    _head_query.transform = Transform3D(Basis.IDENTITY, camera.global_position)
    _head_query.motion = Vector3.ZERO
    return not state.intersect_shape(_head_query, 1).is_empty()

func _apply_stair_support(delta: float) -> void:
    if not use_stair_support or not floor_ray:
        _reset_pid()
        return
    floor_ray.force_raycast_update()
    if not floor_ray.is_colliding():
        _reset_pid()
        return
    if floor_ray.get_collision_normal().dot(Vector3.UP) < cos(floor_max_angle):
        _reset_pid()
        return
    var floor_y := to_local(floor_ray.get_collision_point()).y
    var error := floor_y # doel is 0: de oorsprong van het lichaam ligt op de vloer.
    _integral = clampf(_integral + error * delta, -integral_limit, integral_limit)
    var derivative := (floor_y - _last_value) / delta if _has_last_value else 0.0
    _last_value = floor_y
    _has_last_value = true
    # Deze tutorialvariant levert een snelheidsaanpassing per physics-tick.
    velocity += global_basis.y * (kp * error + ki * _integral + kd * derivative)

func _reset_pid() -> void:
    _integral = 0.0
    _has_last_value = false

func _set_effects(fade: float, turn_input: float) -> void:
    if _fade_material:
        _fade_material.set_shader_parameter("alpha", fade)
        fade_mesh.visible = fade > 0.0
    if _vignette_material:
        var radius := clampf(1.0 - absf(turn_input) * vignette_strength, 0.0, 1.0)
        _vignette_material.set_shader_parameter("radius", radius * sqrt(2.0))
        vignette_mesh.visible = radius < 1.0
