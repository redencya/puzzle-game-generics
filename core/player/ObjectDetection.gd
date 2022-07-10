extends RayCast

var current_body : RigidBody = null
onready var Pin = $PinJoint

signal highlight_object(value)

func _process(delta: float) -> void:
	var new_body = get_collider()
	if current_body != new_body:
		if (current_body):
			current_body.set_highlight(false)
		current_body = new_body
		if (current_body):
			current_body.set_highlight(true)
		emit_signal("highlight_object", current_body)

func _input(event: InputEvent) -> void:
	if current_body && event.is_action_pressed("shoot"):
		current_body.set_mode(RigidBody.MODE_STATIC)
		Pin.add_child(current_body)
		current_body.global_transform = Pin.global_transform
