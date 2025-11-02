extends Node3D

@export var mouse_sensitivity := 0.1
@export var max_speed := 50.0
@export var acceleration := 30.0
@export var deceleration := 25.0
@export var boost_multiplier := 2.0
@export var boost_drain_rate := 50.0
@export var boost_recharge_rate := 30.0

var yaw := 0.0
var pitch := 0.0
var velocity := Vector3.ZERO
var current_boost := 100.0
var max_boost := 100.0
var is_boosting := false
var current_speed := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -90, 90)
		rotation_degrees.y = yaw
		$Camera3D.rotation_degrees.x = pitch

func _process(delta):
	if Input.is_action_just_pressed("take_picture"):
		print("Picture taken!")
	
	handle_boost(delta)
	handle_movement(delta)
	apply_velocity(delta)

func handle_boost(delta):
	if Input.is_action_pressed("ui_focus_next"):
		if current_boost > 0:
			is_boosting = true
			current_boost -= boost_drain_rate * delta
			if current_boost < 0:
				current_boost = 0
				is_boosting = false
		else:
			is_boosting = false
	else:
		is_boosting = false
		if current_boost < max_boost:
			current_boost += boost_recharge_rate * delta
			if current_boost > max_boost:
				current_boost = max_boost

func handle_movement(delta):
	var input_dir = Vector3.ZERO
	var camera_basis = get_global_transform().basis
	
	if Input.is_action_pressed("ui_up"):
		input_dir += -camera_basis.z
	if Input.is_action_pressed("ui_down"):
		input_dir += camera_basis.z
	if Input.is_action_pressed("ui_left"):
		input_dir += -camera_basis.x
	if Input.is_action_pressed("ui_right"):
		input_dir += camera_basis.x
	
	if Input.is_action_pressed("ui_page_up"):
		input_dir += camera_basis.y
	if Input.is_action_pressed("ui_page_down"):
		input_dir += -camera_basis.y
	
	input_dir = input_dir.normalized()
	
	var target_speed = max_speed
	if is_boosting:
		target_speed = max_speed * boost_multiplier
	
	if input_dir != Vector3.ZERO:
		current_speed = move_toward(current_speed, target_speed, acceleration * delta)
		velocity = input_dir * current_speed
	else:
		current_speed = move_toward(current_speed, 0.0, deceleration * delta)
		velocity = velocity.normalized() * current_speed

func apply_velocity(delta):
	global_position += velocity * delta

func get_speed_percentage():
	return (current_speed / max_speed) * 100.0

func get_boost_percentage():
	return (current_boost / max_boost) * 100.0
