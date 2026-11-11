shader_type spatial;
render_mode depth_test_disabled, unshaded, cull_disabled, fog_disabled;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float radius : hint_range(0.0, 2.0) = 1.41421356;
uniform float fade : hint_range(0.001, 0.2) = 0.05;
varying float dist;

void vertex() {
    vec2 v = VERTEX.xy;
    dist = length(v);
    if (dist < 1.5) {
        dist = radius;
        v *= radius;
        // Projecteer een punt recht vooruit, apart met de projectie van elk oog.
        vec4 eye = PROJECTION_MATRIX * vec4(0.0, 0.0, -100.0, 1.0);
        v += eye.xy / eye.w;
    }
    POSITION = vec4(v, 1.0, 1.0);
}

void fragment() {
    ALBEDO = color.rgb;
    ALPHA = color.a * clamp((dist - radius) / max(fade, 0.001), 0.0, 1.0);
}
