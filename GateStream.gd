tool
extends StreamInterface
class_name GateStream

enum BoolLogic {
	AND,
	OR,
	XOR,
}

var operator_type
var input_a_name
var input_a = false
var input_b_name
var input_b = false
var outcome

func _get_outcome_value(a: bool, b: bool, x: int) -> bool:
	match x:
		BoolLogic.AND:
			return a && b
		BoolLogic.OR:
			return a || b
		BoolLogic.XOR:
			return a != b
	return false

func _input_stream_recieved(input: bool, sourcename: String):
	if !input_a_name:
		input_a_name = sourcename
	elif !input_b_name && sourcename != input_a_name:
		input_b_name = sourcename
		
	match sourcename:
		input_a_name:
			input_a = input
			if input:
				$AnimationPlayer.play("InputA")
			else:
				$AnimationPlayer.play_backwards("InputA")
		input_b_name:
			input_b = input
			if input:
				$AnimationPlayer.play("InputB")
			else:
				$AnimationPlayer.play_backwards("InputB")
				
	yield($AnimationPlayer, "animation_finished")
	
	outcome = _get_outcome_value(input_a, input_b, operator_type)

	if outcome:
		$AnimationPlayer.play("Outcome")
	else:
		$AnimationPlayer.play_backwards("Outcome")
		
	for target in output:
		connect("stream_input", get_node(target), "_input_stream_recieved", [], CONNECT_REFERENCE_COUNTED)
		emit_signal("stream_input", outcome, name)

func _set(property: String, value) -> bool:
	var return_value = true
	match property:
		"logic/operator_type":
			operator_type = value
		_:
			return_value = false
	return return_value
	
func _get(property: String):
	match property:
		"logic/operator_type":
			return operator_type
	
func _get_property_list() -> Array:
	var properties = []
	
	properties.append({
		name = "GateStream",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY
	})
	
	properties.append({
		name = "logic/operator_type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "AND, OR, XOR"
	})
	
	return properties
