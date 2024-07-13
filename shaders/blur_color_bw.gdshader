shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod : hint_range(0.0, 5.0) = 5.0;
uniform float blend_factor : hint_range(0.0, 1.0) = 0.3;
uniform vec3 overlay = vec3(0.0, 0.0, 0.0);
uniform float saturation : hint_range(0.0, 1.0) = 0.5;
uniform float blur_size : hint_range(0.0, 5.0) = 1.0;
uniform vec3 black_overlay = vec3(0.0, 0.0, 0.0);
uniform float black_blend_factor : hint_range(0.0, 1.0) = 0.3;

vec3 apply_saturation(vec3 color, float sat) {
    float luminance = dot(color, vec3(0.299, 0.587, 0.114));
    return mix(vec3(luminance), color, sat);
}

vec3 soft_light(vec3 base, vec3 blend) {
    return mix(
        sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend),
        base - (1.0 - 2.0 * blend) * base * (1.0 - base),
        step(base, vec3(0.5))
    );
}

void fragment() {
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
    
    // Apply saturation
    vec3 desaturated = apply_saturation(color.rgb, saturation);
    
    // Apply soft light blending mode with overlay
    vec3 blended = soft_light(desaturated, overlay);
    
    // Blend the result with the original color using the blend_factor
    vec3 final_color = mix(desaturated, blended, blend_factor);
    
    // Apply black overlay blending
    final_color = mix(final_color, black_overlay, black_blend_factor);
    
    // Simple blur approximation by averaging neighboring pixels
    vec4 blurred_color = vec4(0.0);
    vec2 offsets[9] = vec2[](
        vec2(-1.0, -1.0), vec2(0.0, -1.0), vec2(1.0, -1.0),
        vec2(-1.0,  0.0), vec2(0.0,  0.0), vec2(1.0,  0.0),
        vec2(-1.0,  1.0), vec2(0.0,  1.0), vec2(1.0,  1.0)
    );

    for (int i = 0; i < 9; i++) {
        blurred_color += texture(SCREEN_TEXTURE, SCREEN_UV + offsets[i] * blur_size * 0.01, lod);
    }
    blurred_color /= 9.0;
    
    // Mix the blurred color with the final color
    COLOR = mix(vec4(final_color, color.a), blurred_color, 0.5);
}
