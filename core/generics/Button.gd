tool
extends StreamInterface
class_name ButtonStream

var input_type
var weight_type
var click_type

var accent_color

func _set(property: String, value) -> bool:
	var return_value = true
	match property:
		"functionality/input_type":
			input_type = value
			property_list_changed_notify()
		"functionality/weight_type":
			weight_type = value
		"functionality/click_type":
			click_type = value
		"cosmetic/accent_color":
			accent_color = value
		_:
			return_value = false
	return return_value

func _get(property: String):
	match property:
		"functionality/input_type":
			return input_type
		"functionality/weight_type":
			return weight_type
		"functionality/click_type":
			return click_type
		"cosmetic/accent_color":
			return accent_color

func _get_property_list() -> Array:
	var properties = []
	properties.append({
		name = "ButtonStream",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY 
	})
	
	properties.append({
		name = "functionality/input_type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Clickable, Weighted"
	})
	if input_type == 1:
		properties.append({
			name = "functionality/weight_type",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "Generic, Cube Only, Player Only"
		})
	else:
		properties.append({
			name = "functionality/click_type",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "Single Use, Multiple Use"
		})
	
	properties.append({
		name = "cosmetic/accent_color",
		type = TYPE_COLOR
	})
	
	properties.append(._get_property_list())
	
	return properties

func _on_Transmitter_area_entered(area: Area) -> void:
	if area.name == "Receiver":
		for target in output:
			connect("stream_input", get_node(target), "_input_stream_recieved", [], CONNECT_REFERENCE_COUNTED)
			emit_signal("stream_input", true, name)

func _on_Transmitter_area_exited(area: Area) -> void:
	if area.name == "Receiver":
		for target in output:
			connect("stream_input", get_node(target), "_input_stream_recieved", [], CONNECT_REFERENCE_COUNTED)
			emit_signal("stream_input", false, name)


