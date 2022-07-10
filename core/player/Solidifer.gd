extends Area


var body_reference : RigidBody
func _on_Solidifer_body_entered(body: Node) -> void:
	if !(body is RigidBody): return
	body_reference = body
	body_reference.set_mode(RigidBody.MODE_KINEMATIC)

func _on_Solidifer_body_exited(body: Node) -> void:
	if !(body is RigidBody): return
	body.set_mode(RigidBody.MODE_RIGID)
	body_reference = null
