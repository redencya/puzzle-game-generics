extends CenterContainer


onready var on  : TextureRect = $CrosshairOn
onready var off : TextureRect = $CrosshairOff

func set_highlight(value : bool) -> void:
	on.set_visible(value)
	off.set_visible(not value)

func _on_RayCast_highlight_object(value):
	set_highlight(value != null)
