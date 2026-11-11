shader_type canvas_item;
render_mode unshaded;

uniform float breedte : hint_range(0.5, 2.0, 0.05) = 1.5;

void vertex() {
    VERTEX.x *= breedte;
}
