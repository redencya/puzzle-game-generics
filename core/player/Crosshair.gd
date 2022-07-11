extends CenterContainer


onready var on  : TextureRect = $CrosshairOn
onready var off : TextureRect = $CrosshairOff

var last_value = false
func set_highlight(value : bool) -> void:
	if last_value != value:
		if value:
			$AnimationPlayer.play("Focus")
		else:
			$AnimationPlayer.play_backwards("Focus")
		last_value = value

func _on_RayCast_highlight_object(value):
	set_highlight(value is RigidBody)
	print(value is RigidBody)
