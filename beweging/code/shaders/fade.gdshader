shader_type spatial;
render_mode depth_test_disabled, unshaded, cull_disabled, fog_disabled;

uniform float alpha : hint_range(0.0, 1.0) = 0.0;

void vertex() {
    // PlaneMesh van 2 bij 2, Face Z; Godot 4.3+ gebruikt reverse Z.
    POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
    ALBEDO = vec3(0.0);
    ALPHA = alpha;
}
