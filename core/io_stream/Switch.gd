tool
extends Spatial
class_name StreamInterface, "res://core/io_stream/io-icon.svg"

signal stream_input(input, source)

enum StreamType {
	SOURCE,
	SINK,
	TRANSFORMATIVE
}

var type
var enabled
var immutable = true
var stream_mode
var duration
var input
var output

func _input_stream_received(input: bool, sourcename: String):
	enabled = input

func _set(property: String, value) -> bool:
	var return_value := true
	
	match property:
		"general/immutable":
			immutable = value
		"general/enabled":
			enabled = value
		"general/type":
			type = value
			property_list_changed_notify()
		"input/duration":
			duration = value
		"input/stream_mode":
			stream_mode = value
		"relations/input":
			input = value
			if Engine.is_editor_hint():
				for val in value:
					var relative = get_node(val)
					if !(relative.get_path_to(self) in relative.output):
						if !relative.output: 
							input = [(relative.get_path_to(self))]
						else:
							relative.output += [(relative.get_path_to(self))]
						relative.property_list_changed_notify()
		"relations/output":
			output = value
			if Engine.is_editor_hint():
				for val in value:
					var relative = get_node(val)
					if !(relative.get_path_to(self) in relative.input):
						if !relative.input: 
							input = [(relative.get_path_to(self))]
						else:
							relative.input += [(relative.get_path_to(self))]
						relative.property_list_changed_notify()
		_: 
			return_value = false
	return return_value

func _get(property: String):
	match property:
		"general/immutable":
			return immutable
		"general/enabled":
			return enabled
		"general/type":
			return type
		"input/duration":
			return duration
		"input/stream_mode":
			return stream_mode
		"relations/input":
			return input
		"relations/output":
			return output
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
		name = "general/type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Source, Sink, Transformative"
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
		name = "Relations",
		type = TYPE_NIL,
		hint_string = "relations_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE 
	})
	
	if type == StreamType.TRANSFORMATIVE || type == StreamType.SINK:
		properties.append({
			name = "relations/input",
			type = TYPE_ARRAY,
			hint = 24,
			hint_string = str(TYPE_NODE_PATH) + ":"
		})
	if type == StreamType.TRANSFORMATIVE || type == StreamType.SOURCE:
		properties.append({
			name = "relations/output",
			type = TYPE_ARRAY,
			hint = 24,
			hint_string = str(TYPE_NODE_PATH) + ":"
		})

	return properties
