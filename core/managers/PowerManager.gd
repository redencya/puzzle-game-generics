extends Node

var powered_objects = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_power"):
		reset()

func reset():
	for object in powered_objects:
		object.active = false
	powered_objects = []

func power_object(object):
	object.active = true
	powered_objects.append(object)
