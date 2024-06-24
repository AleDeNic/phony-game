shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float lod: hint_range(0.0, 5.0) = 2.0;
uniform float effect_amount : hint_range(-2.5, 2.5) = 0.8;

void fragment() {
    // Fetch screen resolution
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec4 fragCoord = FRAGCOORD;

    // Normalized coordinates
    vec2 p = fragCoord.xy / iResolution.x;

    // Screen proportion
    float prop = iResolution.x / iResolution.y;

    // Center coordinates
    vec2 m = vec2(0.5, 0.5 / prop);

    // Vector from center to current fragment
    vec2 d = p - m;

    // Distance of pixel from center
    float r = sqrt(dot(d, d));

    float power = effect_amount;

    // Radius of 1:1 effect
    float bind;
    if (power > 0.0) {
        bind = sqrt(dot(m, m));
    } else {
        if (prop < 1.0) {
            bind = m.x;
        } else {
            bind = m.y;
        }
    }

    // UV coordinates for fisheye effect
    vec2 uv;
    if (power > 0.0) {
        uv = m + normalize(d) * tan(r * power) * bind / tan(bind * power);
    } else if (power < 0.0) {
        uv = m + normalize(d) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
    } else {
        uv = p;
    }
    uv.y *= prop;

    // Apply blur effect to the texture
    vec4 blurredColor = texture(SCREEN_TEXTURE, uv, lod);

    // Output the combined effect
    COLOR = blurredColor;
}
