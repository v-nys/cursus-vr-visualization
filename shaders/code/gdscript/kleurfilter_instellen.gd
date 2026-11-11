extends Sprite2D

# Optioneel bij voorbeeld 2. Koppel aan dezelfde Sprite2D als het shadermateriaal.
func _ready() -> void:
    var shader_material := material as ShaderMaterial
    if shader_material:
        shader_material.set_shader_parameter("tint", Color(1.0, 0.7, 0.7, 1.0))
