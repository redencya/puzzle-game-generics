tool
extends StreamInterface
class_name ButtonStream

const TOTAL_ANGULAR_LOCK = [
	PhysicsServer.BODY_AXIS_ANGULAR_X,
	PhysicsServer.BODY_AXIS_ANGULAR_Y,
	PhysicsServer.BODY_AXIS_ANGULAR_Z
]

var input_type
var weight_type
var cube_type
var click_type

var accent_color

func _ready() -> void:
	for target in output:
		connect("stream_input", get_node(target), "_input_stream_recieved")
	if weight_type == 1:
		var text_dict = {
			0 : "Square",
			1 : "Triangle",
			2 : "Circle"
		}
		$Sprite3D/TextViewport/Mode.set_text(text_dict[cube_type])

func _process(delta: float) -> void:
	if Engine.is_editor_hint() && weight_type == 1:
		var text_dict = {
			0 : "Square",
			1 : "Triangle",
			2 : "Circle"
		}
		$Sprite3D/TextViewport/Mode.set_text(text_dict[cube_type])

func _set(property: String, value) -> bool:
	var return_value = true
	match property:
		"functionality/input_type":
			input_type = value
			property_list_changed_notify()
		"functionality/weight_type":
			weight_type = value
			property_list_changed_notify()
		"functionality/click_type":
			click_type = value
		"functionality/cube_type":
			cube_type = value
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
		"functionality/cube_type":
			return cube_type
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
		hint_string = "Clickable,Weighted"
	})
	if input_type == 1:
		properties.append({
			name = "functionality/weight_type",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "Generic,Cube Only,Player Only"
		})
		
		if weight_type == 1:
			properties.append({
				name = "functionality/cube_type",
				type = TYPE_INT,
				hint = PROPERTY_HINT_ENUM,
				hint_string = "Square,Triangle,Circle"
			})
		
	else:
		properties.append({
			name = "functionality/click_type",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "Single Use,Multiple Use"
		})
	
	properties.append({
		name = "cosmetic/accent_color",
		type = TYPE_COLOR
	})
	
	properties.append(._get_property_list())
	
	return properties

func _on_ExternalFactorChecker_body_entered(body: Node) -> void:
	if !validate_input(weight_type, body, true): return
	emit_signal("stream_input", true, name)
	$AnimationPlayer.play("Press")
	
func _on_ExternalFactorChecker_body_exited(body: Node) -> void:
	if !validate_input(weight_type, body, false): return
	emit_signal("stream_input", false, name)
	$AnimationPlayer.play_backwards("Press")

func set_total_angular_axis_lock(body, is_true):
	for axis in TOTAL_ANGULAR_LOCK:
		body.set_axis_lock(axis, is_true)

func validate_input(weight, body, entering) -> bool:
	match weight:
		0:
			return true
		1:
			if !(body is Cube): return false
			set_total_angular_axis_lock(body, entering)
			return body.type == cube_type
		2:
			return body is Player
	return false
