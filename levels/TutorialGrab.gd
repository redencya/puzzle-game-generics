extends Area

var current_body : Player

func _process(delta: float) -> void:
	if current_body && current_body.grabber.hold_mode:
		current_body.crosshair_animate.play_backwards("TutorialObjectGrab")
		yield(current_body.crosshair_animate, "animation_finished")
		queue_free()

func _on_Area_body_entered(body: Node) -> void:
	if body is Player:
		current_body = body
		current_body.crosshair_animate.play("TutorialObjectGrab")

func _on_Area_body_exited(body: Node) -> void:
	if body is Player:
		current_body = body
		current_body.crosshair_animate.play_backwards("TutorialObjectGrab")
