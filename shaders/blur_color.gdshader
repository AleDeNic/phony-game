shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5.0) = 4.0;
uniform vec4 blending = vec4(1.0, 1.0, 1.0, 1.0);
uniform float blend_factor: hint_range(0.0, 1.0) = 0.3;

void fragment(){
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
    vec3 overlay = vec3(0.0, 0.0, 0.2);
    color.rgb = mix(color.rgb, overlay, blending.a * blend_factor);
    COLOR = vec4(color.rgb, 1.0);
}
