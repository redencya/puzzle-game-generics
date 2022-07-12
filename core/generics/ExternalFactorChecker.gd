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

func validate_input(weight_type, body, entering) -> bool:
	match weight_type:
		0:
			return true
		1:
			if !(body is Cube): return false
			return (body.type == owner.cube_type) && body.active
		2:
			return body is Player
	return false
