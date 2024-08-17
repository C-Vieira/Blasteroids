shader_type canvas_item;

uniform float x_offset = 0.0;
uniform float y_offset = 1.0;
uniform float animation_speed = 0.005;
uniform vec4 color : source_color = vec4(1.0);
uniform sampler2D noise_texture: hint_default_black, repeat_enable;

void fragment() {
	vec2 uv = vec2(UV.x, UV.y + TIME * animation_speed);
	vec4 noise_color = texture(noise_texture, uv);
	vec4 final_color = noise_color;
	
	final_color.rgb += vec3(2.0 * UV.x - x_offset);
	final_color.rgb += vec3(UV.y - y_offset);
	
	final_color.rgb = step(final_color.rgb, vec3(0.75));
	final_color.rgb = vec3(1.0) - final_color.rgb;
	final_color.a = final_color.r;
	final_color.rgb = color.rgb;
	
	COLOR = final_color;
}
