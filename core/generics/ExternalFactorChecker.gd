extends Area

const TOTAL_ANGULAR_LOCK = [
	PhysicsServer.BODY_AXIS_ANGULAR_X,
	PhysicsServer.BODY_AXIS_ANGULAR_Y,
	PhysicsServer.BODY_AXIS_ANGULAR_Z
]

func _on_ExternalFactorChecker_body_entered(body: Node) -> void:
	if !validate_input(owner.weight_type, body, true): return
	owner.emit_signal("stream_input", true)
	
func _on_ExternalFactorChecker_body_exited(body: Node) -> void:
	if !validate_input(owner.weight_type, body, false): return
	owner.emit_signal("stream_input", false)

func set_total_angular_axis_lock(body, is_true):
	for axis in TOTAL_ANGULAR_LOCK:
		body.set_axis_lock(axis, is_true)
	get_tree() Vector3.ZERO

func validate_input(weight_type, body, entering) -> bool:
	match weight_type:
		0:
			return true
		1:
			if !(body is Cube): return false
			set_total_angular_axis_lock(body, entering)
			return body.type == owner.cube_type
		2:
			return body is Player
	return false
