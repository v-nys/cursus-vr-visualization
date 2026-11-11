extends Node

@export var pivot: Node3D
@export var visual: Node3D
@export var handle: XRToolsPickable
@export var chamber: CourseChamber
@export var travel: float = 0.075
var visual_rest: Vector3
var handle_rest: Transform3D
var latched := false

func _ready() -> void:
    visual_rest = visual.position
    handle_rest = handle.transform

func _physics_process(_delta: float) -> void:
    if not handle.is_picked_up():
        visual.position = visual_rest
        handle.transform = handle_rest
        latched = false
        return
    var local := pivot.to_local(handle.global_position)
    var rest := pivot.to_local((handle.get_parent() as Node3D).to_global(handle_rest.origin))
    var pull := clampf(local.z - rest.z, 0.0, travel)
    visual.position = visual_rest + Vector3(0.0, 0.0, pull)
    if pull >= travel * 0.95 and not latched:
        latched = true
        chamber.cycle()
