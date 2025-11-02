shader_type sky;

uniform vec3 bg_color : source_color = vec3(0.0, 0.0, 0.002);
uniform float star_density = 0.18;
uniform float star_size = 0.015;
uniform float star_brightness = 2.8;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec3 get_star_color(float h) {
    if(h < 0.1) return vec3(0.5, 0.6, 1.0);
    else if(h < 0.2) return vec3(0.6, 0.7, 1.0);
    else if(h < 0.3) return vec3(0.7, 0.8, 1.0);
    else if(h < 0.4) return vec3(0.8, 0.9, 1.0);
    else if(h < 0.5) return vec3(1.0, 1.0, 1.0);
    else if(h < 0.6) return vec3(1.0, 0.98, 0.9);
    else if(h < 0.7) return vec3(1.0, 0.95, 0.8);
    else if(h < 0.85) return vec3(1.0, 0.9, 0.7);
    else return vec3(1.0, 0.75, 0.5);
}

void sky() {
    vec3 d = normalize(EYEDIR);
    
    vec2 uv = vec2(atan(d.z, d.x), acos(d.y)) * 4.0;
    vec3 color = bg_color;
    
    vec2 grid = floor(uv * 15.0);
    
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 cell = grid + vec2(float(x), float(y));
            float h = hash(cell);
            
            if(h > (1.0 - star_density)) {
                vec2 star_pos = cell / 15.0 + vec2(hash(cell + 1.0), hash(cell + 2.0)) * 0.1;
                vec2 diff = uv - star_pos;
                float dist = length(diff);
                
                float star = smoothstep(star_size, 0.0, dist);
                vec3 star_col = get_star_color(hash(cell + 3.0));
                color += star_col * star * star_brightness;
            }
        }
    }
    
    COLOR = color;
}
