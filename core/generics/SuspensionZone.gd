tool
extends Area

var type
var dimensions

func _process(delta: float) -> void:
	set_area_color(type)
	set_area_size(dimensions)
	set_box_size(dimensions)

func set_area_color(suspension_type):
	var color_dict = {
		0 : Color("5aff0000"),
		1 : Color("5a44ff00"),
		2 : Color("5afff500")
	}
	$CSGBox.material.set_shader_param("albedo", color_dict[suspension_type])

func set_box_size(vec: Vector3):
	$CSGBox.width = vec.x * 2
	$CSGBox.height = vec.y * 2
	$CSGBox.depth = vec.z * 2

func set_area_size(vec: Vector3):
	$CollisionShape.shape.extents = vec

func _get(property: String):
	match property:
		"suspension/type":
			return type
		"suspension/dimensions":
			return dimensions
	
func _set(property: String, value) -> bool:
	var return_value = true
	match property:
		"suspension/type":
			type = value
		"suspension/dimensions":
			dimensions = value
		_:
			return_value = false
	return return_value

func _get_property_list() -> Array:
	var p = []
	p.append({
		name = "suspension/type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Red Only,Green Only,Yellow Only"
	})
	p.append({
		name = "suspension/dimensions",
		type = TYPE_VECTOR3
	})
	
	return p

func _on_SuspensionZone_body_entered(body: Node) -> void:
	pass # Replace with function body.
	# Set player suspension mode to current suspension mode

func _on_SuspensionZone_body_exited(body: Node) -> void:
	pass # Replace with function body.
	# Set player suspension mode to no suspension mode
