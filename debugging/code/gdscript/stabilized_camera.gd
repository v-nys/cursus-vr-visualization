# Gebaseerd op Bastiaan Olij, tutorialbranch spectator_view (MIT).
extends Camera3D

@export var xr_camera: XRCamera3D
@export_range(0.01, 1.0, 0.01, "suffix:s") var smooth_delay: float = 0.1

var _previous := Transform3D.IDENTITY
var _initialized: bool = false

func _ready() -> void:
    process_priority = 10
    reset_smoothing()

# Ook bruikbaar na teleportatie, recentering of een camerawissel.
func reset_smoothing() -> void:
    _initialized = false
    if is_instance_valid(xr_camera):
        _previous = _without_roll(xr_camera.transform)
        _initialized = true

func _without_roll(value: Transform3D) -> Transform3D:
    var forward := -value.basis.z.normalized()
    # Nabij recht omhoog/omlaag is de keuze van een horizon niet eenduidig.
    if absf(forward.dot(Vector3.UP)) < 0.999:
        value.basis = Basis.looking_at(forward, Vector3.UP)
    else:
        value.basis = value.basis.orthonormalized()
    return value

func _process(delta: float) -> void:
    if not is_instance_valid(xr_camera):
        return
    var origin := xr_camera.get_parent() as Node3D
    if not origin:
        return
    if not _initialized:
        reset_smoothing()
    var target := _without_roll(xr_camera.transform)
    var weight := 1.0 - exp(-delta / maxf(smooth_delay, 0.001))
    _previous.basis = _previous.basis.slerp(target.basis, weight)
    _previous.origin = _previous.origin.lerp(target.origin, weight)
    # Smoothing in trackingruimte; verplaatsing van de origin komt direct mee.
    global_transform = origin.global_transform * _previous
