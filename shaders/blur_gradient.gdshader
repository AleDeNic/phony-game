shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float max_lod : hint_range(0.0, 5.0) = 4.0;

void fragment() {
    // Calculate the LOD based on the y-coordinate
    float lod = SCREEN_UV.y * max_lod;  // LOD ranges from 0 at the top to max_lod at the bottom

    // Sample the screen texture with the calculated LOD
    vec4 blurred_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, lod);

    // Set the final color
    COLOR = blurred_color;
}
