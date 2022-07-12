tool
extends StreamInterface

func _input_stream_recieved(input: bool, _sourcename: String):
	if input:
		$AnimationPlayer.play("Move")
	else:
		$AnimationPlayer.stop(false)
