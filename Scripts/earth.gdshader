shader_type spatial;
render_mode unshaded;

uniform sampler2D earth_texture;
uniform vec3 light_dir;
uniform float rotation_speed = 0.1;
uniform float time_passed = 0.0;

void fragment() {
    float scroll = fract(UV.x + time_passed * rotation_speed);
    vec2 uv_rot = vec2(scroll, UV.y);

    vec4 tex_color = texture(earth_texture, uv_rot);

    float light_intensity = max(dot(NORMAL, -light_dir), 0.0);

    vec3 day_color = tex_color.rgb * light_intensity;

    float night_glow = (1.0 - light_intensity) * smoothstep(0.2, 0.5, dot(tex_color.rgb, vec3(0.333)));

    vec3 final_color = mix(day_color, day_color + vec3(night_glow) * 0.5, (1.0 - light_intensity));

    ALBEDO = final_color;
    ALPHA = tex_color.a;

    EMISSION = vec3(night_glow) * 0.3;
}
