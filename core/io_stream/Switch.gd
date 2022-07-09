tool
extends Spatial
class_name StreamInterface, "res://core/io_stream/io-icon.svg"

var enabled
var immutable = true
var stream_mode
var duration
var targets

func _set(property: String, value) -> bool:
	var return_value := true
	
	match property:
		"general/immutable":
			immutable = value
		"general/enabled":
			enabled = value
		"input/duration":
			duration = value
		"input/stream_mode":
			stream_mode = value
		"output/targets":
			targets = value
		_: 
			return_value = false
	return return_value

func _get(property: String):
	match property:
		"general/immutable":
			return immutable
		"general/enabled":
			return enabled
		"input/duration":
			return duration
		"input/stream_mode":
			return stream_mode
		"output/targets":
			return targets
	return

func _get_property_list() -> Array:
	var properties = []

	properties.append({
		name = "StreamInterface",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY 
	})

	properties.append({
		name = "general/immutable",
		type = TYPE_BOOL
	})

	properties.append({
		name = "general/enabled",
		type = TYPE_BOOL
	})
	
	properties.append({
		name = "input/stream_mode",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Hold, Oneshot"
	})
	
	properties.append({
		name = "input/duration",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0, 5, 0.01"
	})
	
	properties.append({
		name = "output/targets",
		type = TYPE_ARRAY,
		hint = 24,
		hint_string = str(TYPE_NODE_PATH) + ":"
	})

	return properties
