shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5.0) = 5.0;
uniform vec4 blending = vec4(1.0, 1.0, 1.0, 1.0);
uniform float blend_factor: hint_range(0.0, 1.0) = 0.3;

void fragment(){
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
    
    // Convert the color to grayscale
    float gray = dot(color.rgb, vec3(0.3, 0.3, 0.3));
    
    // Create a grayscale color
    vec3 grayscale = vec3(gray);
    
    // Define your overlay color
    vec3 overlay = vec3(0.0, 0.0, 0.0);
    
    // Blend the grayscale color with the overlay color
    color.rgb = mix(grayscale, overlay, blending.a * blend_factor);
    
    // Output the final color
    COLOR = vec4(color.rgb, 1.0);
}

