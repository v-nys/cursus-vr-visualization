# Koppel aan de Control-root van de spectator-scène, niet aan de XR-hoofdscène.
extends Control

@export var hmd: SubViewport
@export var first_person_viewport: SubViewport
@export var xr_camera: XRCamera3D
@export var third_person_camera: Camera3D
@export var inset_camera: Camera3D
@export var fov_slider: HSlider

const WORLD_LAYER: int = 1 << 0
const HMD_LAYER: int = 1 << 1
const SPECTATOR_LAYER: int = 1 << 2
const FIRST_PERSON_LAYER: int = 1 << 3

func _ready() -> void:
    if not hmd or not first_person_viewport or not xr_camera \
            or not third_person_camera or not inset_camera or not fov_slider:
        push_error("Koppel alle spectator-referenties in de Inspector.")
        return
    var desktop := get_viewport()
    desktop.use_xr = false
    # De bestaande Main-scène schakelt hmd.use_xr in na OpenXR-initialisatie.
    var shared_world := desktop.find_world_3d()
    hmd.own_world_3d = false
    first_person_viewport.own_world_3d = false
    hmd.world_3d = shared_world
    first_person_viewport.world_3d = shared_world
    first_person_viewport.use_xr = false
    first_person_viewport.size = Vector2i(300, 300)
    first_person_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
    xr_camera.cull_mask = WORLD_LAYER | HMD_LAYER
    third_person_camera.cull_mask = WORLD_LAYER | SPECTATOR_LAYER
    inset_camera.cull_mask = WORLD_LAYER | FIRST_PERSON_LAYER
    xr_camera.make_current()
    third_person_camera.make_current()
    inset_camera.make_current()
    fov_slider.min_value = 60.0
    fov_slider.max_value = 120.0
    fov_slider.step = 1.0
    fov_slider.set_value_no_signal(inset_camera.fov)
    fov_slider.value_changed.connect(_on_fov_changed)

func _on_fov_changed(value: float) -> void:
    inset_camera.fov = value
