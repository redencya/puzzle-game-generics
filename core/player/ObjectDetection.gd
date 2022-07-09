extends RayCast

func _process(delta: float) -> void:
	get_collider()

func _input(event: InputEvent) -> void:
	if get_collider() && event.is_action_pressed("shoot"):
		get_collider().global_transform = $PinJoint.global_transform
