tool
extends KinematicBody
class_name Player

var gameplay_restriction_mode: int
var gameplay_bullet

var move_speed = 20
var move_run_speed = 1.25

var control_acceleration = 0.25
var control_deceleration = 0.25
var control_acceleration_air = 0.25
var control_deceleration_air = 0.25

var physics_falling = 20
var physics_rising = 40
var physics_jump_force = 10
var physics_collision_push = 50

func _process(delta: float) -> void:
	$CanvasLayer/ViewportContainer/Viewport/Camera.global_transform = $Camera.global_transform

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") && !$AnimationPlayer.is_playing():
		var b = gameplay_bullet.instance()
		owner.add_child(b)
		b.global_transform.origin = $Camera/Muzzle.global_transform.origin
		b.velocity = $Camera/Muzzle.global_transform.origin.direction_to($Camera/Muzzle2.global_transform.origin) * b.muzzle_velocity
		$AnimationPlayer.play("GunMove")
	
	if event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED * int(OS.is_window_fullscreen()))

	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x)*0.3)
		$Camera.rotation.x = clamp($Camera.rotation.x + (deg2rad(-event.relative.y)*0.3), deg2rad(-89.9), deg2rad(89.9))

# Creates a velocity vector with relative camera positioning.
func construct_velocity(phi: float, dir: Vector2, speed: float, gforce: float) -> Vector3:
	previous_speed_reference = speed
	var dir_proper = dir.rotated(-phi) * speed
	return Vector3(dir_proper.x, gforce, dir_proper.y)

# This impurity is required to make acceleration and deceleration possible.
var previous_speed_reference: float
func calculate_move_speed(idle: bool, speed_control: Array, limit: float):
	return clamp(previous_speed_reference + (speed_control[int(idle)]), 0, limit)

func calculate_gravity(delta: float, previous_y: float, gravity_factor: float, is_jumping: bool):
	if is_jumping: return physics_jump_force
	return previous_y - (gravity_factor * delta)

var previous_speed = move_speed
func choose_move_speed(running: bool) -> float:
	var speed_to_return
	if running:
		speed_to_return = lerp(previous_speed, move_speed * move_run_speed, 0.1)
	else:
		speed_to_return = lerp(previous_speed, move_speed, 0.1)
	previous_speed = speed_to_return
	return speed_to_return

func choose_speed_control(grounded = is_on_floor()) -> Array:
	if grounded:
		return [control_acceleration, -control_deceleration]
	return [control_acceleration_air, -control_deceleration_air]

func choose_gravity_factor(previous_y: float) -> float:
	if previous_y > 0: return physics_falling
	return physics_rising

var velocity: Vector3
var input_vector = Vector2.UP
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var previous_input = input_vector
	input_vector = Input.get_vector(
		"strafe_left",
		"strafe_right",
		"forward",
		"backward"
	)
	var direction = input_vector if input_vector != Vector2.ZERO else previous_input
	
	velocity = construct_velocity(
		rotation.y,
		direction,
		calculate_move_speed(
			input_vector == Vector2.ZERO, 
			choose_speed_control(), 
			choose_move_speed(Input.is_action_pressed("run"))
			),
		calculate_gravity(
			delta, 
			velocity.y, 
			choose_gravity_factor(velocity.y), 
			Input.is_action_just_pressed("jump") && is_on_floor()
			)
	)
	var snap = Vector3.ZERO if Input.is_action_just_pressed("jump") && is_on_floor() else -get_floor_normal() * 4
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, PI/4, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * physics_collision_push * velocity.length())

func _get_property_list() -> Array:
	var properties := []
	
	properties.append({
		name = "Gameplay",
		type = TYPE_NIL,
		hint_string = "gameplay_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})

	properties.append({
		name = "gameplay_bullet",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "PackedScene"
	})

	properties.append({
		name = "Movement",
		type = TYPE_NIL,
		hint_string = "move_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	properties.append({
		name = "move_speed",
		type = TYPE_REAL,
	})
	
	properties.append({
		name = "move_run_speed",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "1.1, 5, 0.1"
	})


	properties.append({
		name = "Speed Control",
		type = TYPE_NIL,
		hint_string = "control_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	properties.append({
		name = "control_acceleration",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_EXP_EASING,
	})
	
	properties.append({
		name = "control_deceleration",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_EXP_EASING,
	})
	
	properties.append({
		name = "control_acceleration_air",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_EXP_EASING,
	})
	
	properties.append({
		name = "control_deceleration_air",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_EXP_EASING,
	})


	properties.append({
		name = "Physics",
		type = TYPE_NIL,
		hint_string = "physics_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	properties.append({
		name = "physics_falling",
		type = TYPE_REAL
	})
	
	properties.append({
		name = "physics_rising",
		type = TYPE_REAL
	})
	
	properties.append({
		name = "physics_jump_force",
		type = TYPE_REAL
	})
	
	properties.append({
		name = "physics_collision_push",
		type = TYPE_REAL
	})
	
	return properties



