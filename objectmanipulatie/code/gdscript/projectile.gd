extends RigidBody3D

func _ready() -> void:
    get_tree().create_timer(3.0).timeout.connect(queue_free)
