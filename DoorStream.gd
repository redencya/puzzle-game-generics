tool
extends StreamInterface
class_name DoorStream

func _input_stream_recieved(input: bool, _sourcename: String):
	._input_stream_received(input, _sourcename)
	if input:
		$AnimationPlayer.play("Open")
	elif $AnimationPlayer.get_assigned_animation() == "Open":
		$AnimationPlayer.play_backwards("Open")
