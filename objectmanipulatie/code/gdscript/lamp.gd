extends Node

@export var light: OmniLight3D

func _ready() -> void:
    var pickable := get_parent() as XRToolsPickable
    pickable.action_pressed.connect(_on_action_pressed)

func _on_action_pressed(_pickable: Node3D) -> void:
    light.visible = not light.visible
