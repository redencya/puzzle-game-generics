extends Spatial

export (String) var path = "res://"

func _on_Area_body_entered(body):
	if body is KinematicBody and body.is_in_group("player"):
		SceneSwitcher.change_scene(path)
		
