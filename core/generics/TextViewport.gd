tool
extends Viewport

export (String) var text

func _process(delta: float) -> void:
	$Mode.text = text
