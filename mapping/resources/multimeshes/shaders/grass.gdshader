shader_type spatial;
render_mode skip_vertex_transform, cull_disabled, vertex_lighting, alpha_to_coverage;

uniform vec3 albedo_color: source_color = vec3(1.0, 1.0, 1.0);
uniform sampler2D albedo_texture: source_color, hint_default_white;

uniform float alpha_scissor_threshold: hint_range(0.0, 1.0, 0.001) = 0.0;
uniform float alpha_antialiasing_edge: hint_range(0.0, 1.0, 0.001) = 0.3;

uniform float color_variation_strength: hint_range(0.0, 1.0, 0.001) = 0.05;
uniform vec3 color_variation_scale = vec3(1.0, 0.1, 0.3);

uniform vec2 wind_direction = vec2(-1.0, 1.0);
uniform float wind_speed = 8.0;
uniform float wind_strength: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform sampler2D wind_noise_texture: source_color, repeat_enable, hint_default_black;
uniform float wind_noise_scale = 1024.0; // area in meteres covered by texture

varying vec3 color_variation;


void vertex() {
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 up_direction = MODEL_MATRIX[1].xyz;
	vec3 up_direction_normalized = normalize(up_direction);
	float height = abs(VERTEX.y) * length(up_direction);

	vec2 wind_direction_normalized = normalize(wind_direction);
	vec2 wind_noise_uv = (world_position.xz - wind_direction_normalized * TIME * wind_speed) / wind_noise_scale;
	float wind_noise_mask = texture(wind_noise_texture, wind_noise_uv).r;
	vec2 wind_offset_direction_xz = sqrt(wind_strength * (2.0 - wind_strength)) * wind_direction_normalized;
	vec3 wind_offset_direction = vec3(wind_offset_direction_xz.x, -wind_strength, wind_offset_direction_xz.y);
	vec3 wind_offset = wind_offset_direction * height * wind_noise_mask;

	vec3 color_variation_noise = fract(sin(float(INSTANCE_ID) + world_position) * 43758.5453123);
	float color_variation_scale_max = max(max(color_variation_scale.x, color_variation_scale.y), color_variation_scale.z);
	vec3 color_variation_scale_boxed = (color_variation_scale / color_variation_scale_max);
	color_variation = (2.0 * color_variation_noise - 1.0) * color_variation_scale_boxed * color_variation_strength;

	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz + wind_offset;
	VERTEX = (VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	NORMAL = up_direction_normalized;
}


void fragment() {
	vec4 albedo_texture_color = texture(albedo_texture, UV);
	ALBEDO = clamp(fma(albedo_texture_color.rgb, albedo_color, color_variation), 0.0, 1.0);
	ALPHA = albedo_texture_color.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
	ALPHA_ANTIALIASING_EDGE = alpha_antialiasing_edge;
	ROUGHNESS = 0.95;
	METALLIC = 0.0;
	SPECULAR = 0.15;
}