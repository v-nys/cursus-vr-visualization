class_name CourseChamber
extends Node

enum State { EMPTY, LIVE, SPENT }
@export var magazine_zone: XRToolsSnapZone
@export var muzzle: Marker3D
@export var projectile_scene: PackedScene
@export var speed: float = 8.0
var state: State = State.EMPTY

func _ready() -> void:
    (get_parent() as XRToolsPickable).action_pressed.connect(_on_action)

func cycle() -> void:
    # Uitwerpen wordt hier alleen in het toestandsmodel verwerkt.
    state = State.EMPTY
    var item := magazine_zone.picked_up_object
    if is_instance_valid(item):
        var magazine := item.get_node_or_null("Magazine") as CourseMagazine
        if magazine != null and magazine.take_round():
            state = State.LIVE

func _on_action(_pickable: Node3D) -> void:
    if state != State.LIVE:
        print("Klik: geen geladen patroon")
        return
    if projectile_scene == null:
        return
    var instance := projectile_scene.instantiate()
    var projectile := instance as RigidBody3D
    if projectile == null:
        instance.queue_free()
        push_error("Projectile heeft geen RigidBody3D-root")
        return
    get_tree().current_scene.add_child(projectile)
    projectile.global_transform = muzzle.global_transform
    projectile.linear_velocity = -muzzle.global_basis.z.normalized() * speed
    state = State.SPENT
