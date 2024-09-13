shader_type canvas_item;

uniform vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float multiplier = -0.25;
uniform float smoothness = 3;

void fragment() 
{
	float value = distance(UV, vec2(0.5));
	COLOR = vec4(color.rgb, smoothstep(multiplier, smoothness, value));
}