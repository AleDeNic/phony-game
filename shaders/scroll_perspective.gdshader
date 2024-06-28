shader_type canvas_item;

// Uniforms for scrolling effect
uniform vec2 scroll_speed = vec2(1.0, 0.0); // Speed of scrolling in UV space

// Uniforms for distortion effect
uniform float fov = 90.0; // Camera FOV
uniform bool cull_back = true;
uniform float y_rot = 0.0; // Y-axis rotation
uniform float x_rot = 0.0; // X-axis rotation
uniform float inset = 0.0; // Inset value for distortion effect

varying vec2 distortion_uv;
varying vec3 distortion_pos;

void vertex() {
    // Apply scrolling effect to UV coordinates
    vec2 scrolled_uv = mod(UV + TIME * scroll_speed, 1.0);
    UV = scrolled_uv;

    // Calculate distortion effect
    float sin_b = sin(radians(y_rot));
    float cos_b = cos(radians(y_rot));
    float sin_c = sin(radians(x_rot));
    float cos_c = cos(radians(x_rot));

    mat3 inv_rot_mat;
    inv_rot_mat[0] = vec3(cos_b, 0.0, -sin_b);
    inv_rot_mat[1] = vec3(sin_b * sin_c, cos_c, cos_b * sin_c);
    inv_rot_mat[2] = vec3(sin_b * cos_c, -sin_c, cos_b * cos_c);

    float t = tan(radians(fov) / 2.0);
    vec3 distorted_pos = inv_rot_mat * vec3((UV - 0.5) * (1.0 - inset), 0.5 / t);
    distortion_pos = distorted_pos;
    float v = (0.5 / t) + 0.5;
    distortion_uv = v * distorted_pos.xy + 0.5;

    // Apply inset
    VERTEX += (UV - 0.5) * (1.0 - inset);
}

void fragment() {
    // Calculate distortion effect
    if (cull_back && distortion_pos.z <= 0.0) discard;
    vec2 uv_distort = (distortion_uv / distortion_pos.z).xy;
    vec4 distorted_color = texture(TEXTURE, uv_distort);
    distorted_color.a *= step(max(abs(uv_distort.x), abs(uv_distort.y)), 0.5);

    // Output final color
    COLOR = distorted_color;
}
