shader_type canvas_item;

uniform sampler2D overlay : source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 overlay_color = vec4(1.0, 1.0, 1.0, 1.0);

vec3 soft_light(vec3 base, vec3 blend) {
    return vec3(
        (blend.r < 0.5) ? (2.0 * base.r * blend.r + base.r * base.r * (1.0 - 2.0 * blend.r)) : 
                           (sqrt(base.r) * (2.0 * blend.r - 1.0) + base.r * (1.0 - (2.0 * blend.r - 1.0))),
        (blend.g < 0.5) ? (2.0 * base.g * blend.g + base.g * base.g * (1.0 - 2.0 * blend.g)) : 
                           (sqrt(base.g) * (2.0 * blend.g - 1.0) + base.g * (1.0 - (2.0 * blend.g - 1.0))),
        (blend.b < 0.5) ? (2.0 * base.b * blend.b + base.b * base.b * (1.0 - 2.0 * blend.b)) : 
                           (sqrt(base.b) * (2.0 * blend.b - 1.0) + base.b * (1.0 - (2.0 * blend.b - 1.0)))
    );
}

void fragment() {
    vec4 overlay_sample = texture(overlay, SCREEN_UV) * overlay_color;
    vec4 screen_sample = texture(screen_texture, SCREEN_UV);

    // Apply soft light blending mode
    vec3 blended_rgb = soft_light(screen_sample.rgb, overlay_sample.rgb);

    // Blend the result based on the alpha of the overlay color
    COLOR.rgb = mix(screen_sample.rgb, blended_rgb, overlay_color.a);
    COLOR.a = screen_sample.a;
}
