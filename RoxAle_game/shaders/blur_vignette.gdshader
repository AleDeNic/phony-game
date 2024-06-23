shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5.0) = 2.0;
uniform vec2 center = vec2(0.5, 0.5); // Center of the screen
uniform float radius: hint_range(0.0, 1.0) = 0.3; // Radius of the crisp area
uniform float blur_strength: hint_range(0.0, 1.0) = 0.4; // Strength of the blur

void fragment() {
    // Convert UV coordinates to screen space
    vec2 uv = SCREEN_UV;

    // Compute the distance from the center of the screen
    float dist = distance(uv, center);

    // Create a vignette mask based on the distance from the center
    float vignette = smoothstep(radius, radius + blur_strength, dist);

    // Sample the screen texture with and without LOD
    vec4 color_crisp = texture(SCREEN_TEXTURE, uv); // Crisp (no LOD)
    vec4 color_blur = texture(SCREEN_TEXTURE, uv, lod); // Blurred (with LOD)

    // Mix between the crisp and blurred textures based on the vignette mask
    vec4 color = mix(color_crisp, color_blur, vignette);

    // Set the final color
    COLOR = color;
}
