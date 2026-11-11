# Gebaseerd op Bastiaan Olij, tutorialbranch spectator_view (MIT).
extends Camera3D

@export var target: Node3D

func _ready() -> void:
    process_priority = 10 # Na de gebruikelijke gameplay-_process met prioriteit 0.

func _process(_delta: float) -> void:
    if not is_instance_valid(target):
        return
    var direction := target.global_position - global_position
    if direction.length_squared() < 0.000001:
        return
    var up := Vector3.UP
    if absf(direction.normalized().dot(up)) > 0.999:
        up = Vector3.FORWARD
    look_at(target.global_position, up)
