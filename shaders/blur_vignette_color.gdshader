shader_type canvas_item;

uniform sampler2D overlay : source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform vec4 overlay_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float blur_radius : hint_range(0, 1) = 0.25; // Radius of the blur effect
uniform float blur_amount : hint_range(0, 5) = 4.0; // Strength of the blur effect
uniform float blur_inner : hint_range(0, 1) = 0.6; // Inner edge of the blur effect
uniform float blur_outer : hint_range(0, 1) = 0.7; // Outer edge of the blur effect

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
    // Step 1: Apply soft light blending mode
    vec4 overlay_sample = texture(overlay, SCREEN_UV) * overlay_color;
    vec4 screen_sample = texture(screen_texture, SCREEN_UV);
    vec3 blended_rgb = soft_light(screen_sample.rgb, overlay_sample.rgb);
    COLOR.rgb = mix(screen_sample.rgb, blended_rgb, overlay_color.a);
    COLOR.a = screen_sample.a;

    // Step 2: Apply blur vignette effect
    vec4 blur_color = textureLod(screen_texture, SCREEN_UV, blur_amount);
    float distance = length(SCREEN_UV - vec2(0.5, 0.5));
    float blur_factor = smoothstep(blur_inner, blur_outer, distance);
    
    // Combine soft light and blur vignette
    COLOR.rgb = mix(COLOR.rgb, blur_color.rgb, blur_factor);
    COLOR.a = mix(COLOR.a, blur_color.a, blur_factor);
}
