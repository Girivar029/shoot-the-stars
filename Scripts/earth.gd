extends MeshInstance3D

@export var rotation_speed = 0.1
var shader_material = null

func _ready():
	# Cache the shader material
	shader_material = material_override
	if shader_material == null:
		push_error("ShaderMaterial not assigned to Earth mesh!")
		return

func _process(delta):
	if shader_material == null:
		return

	# Get current 'time_passed' uniform; initialize to 0 if not set
	var time_passed = 0.0
	if shader_material.has_param("time_passed"):
		time_passed = shader_material.get_shader_param("time_passed")
	time_passed += delta

	# Update shader uniform
	shader_material.set_shader_param("time_passed", time_passed)

	# Optionally update the light_dir uniform (e.g. pass Sun direction)
	var sun_node = get_node_or_null("/root/Main/Sun")
	if sun_node:
		var light_dir = (global_transform.origin - sun_node.global_transform.origin).normalized()
		shader_material.set_shader_param("light_dir", light_dir)
