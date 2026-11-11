shader_type canvas_item;
render_mode unshaded;

uniform vec4 tint : source_color = vec4(0.6, 0.8, 1.0, 1.0);

void fragment() {
    // COLOR bevat hier al de texturekleur en de modulatiekleur van de node.
    COLOR *= tint;
}
