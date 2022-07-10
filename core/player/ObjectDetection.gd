extends RayCast

var current_body : RigidBody = null
onready var pivot = $Position3D

signal highlight_object(value)

var hold_mode: bool = false

func _process(delta: float) -> void:
	get_collider()
	emit_signal("highlight_object", get_collider() != null)

func _physics_process(delta: float) -> void:
	hold_object(hold_mode, current_body)
		
func hold_object(input, object):
	if !(object is RigidBody): return
	if input:
		object.global_transform.origin = pivot.global_transform.origin
	else:
		object.set_mode(RigidBody.MODE_RIGID)
		object.collision_mask = 3
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if get_collider() && !hold_mode:
			current_body = get_collider()
			hold_mode = true
			current_body.collision_mask = 0
			current_body.set_mode(RigidBody.MODE_KINEMATIC)
		elif hold_mode:
			current_body.set_mode(RigidBody.MODE_RIGID)
			current_body.collision_mask = 3
			current_body = null
			hold_mode = false
