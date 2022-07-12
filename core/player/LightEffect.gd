extends RayCast

# THIS IS BAD IMPLEMENTATION BUT IT CAN BE FIXED LATER
# ITS NOT LIKE WE ACTUALLY NEED GOOD CODE RN
var current_body : Cube


func _physics_process(delta: float) -> void:
	
	if get_collider() is Cube:
		current_body = get_collider()
		current_body.active = true
	elif current_body:
		if !(current_body in PowerManager.powered_objects):
			current_body.active = false
		current_body = null
