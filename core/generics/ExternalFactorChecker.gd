extends Area

const TOTAL_ANGULAR_LOCK = [
	PhysicsServer.BODY_AXIS_ANGULAR_X,
	PhysicsServer.BODY_AXIS_ANGULAR_Y,
	PhysicsServer.BODY_AXIS_ANGULAR_Z
]

var body_reference : RigidBody
func _on_ExternalFactorChecker_body_entered(body: Node) -> void:
	if !(body is RigidBody): return
	body_reference = body
	for axis in TOTAL_ANGULAR_LOCK:
		body_reference.set_axis_lock(axis, true)

func _on_ExternalFactorChecker_body_exited(body: Node) -> void:
	if !(body is RigidBody): return
	for axis in TOTAL_ANGULAR_LOCK:
		body_reference.set_axis_lock(axis, false)
	body_reference = null
