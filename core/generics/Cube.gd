tool
extends RigidBody
class_name Cube

const TOTAL_ANGULAR_LOCK = [
	PhysicsServer.BODY_AXIS_ANGULAR_X,
	PhysicsServer.BODY_AXIS_ANGULAR_Y,
	PhysicsServer.BODY_AXIS_ANGULAR_Z
]

const RED = preload("res://assets/CubeSquare_Mat.material")
const YELLOW = preload("res://assets/CubeCircle_Mat.material")
const GREEN = preload("res://assets/CubeTriangle_Mat.material")

var type

func set_total_angular_axis_lock(is_true):
	for axis in TOTAL_ANGULAR_LOCK:
		set_axis_lock(axis, is_true)

func _ready() -> void:
	var text_dict = {
		0 : "Square",
		1 : "Triangle",
		2 : "Circle"
	}
	$Label3D/TextViewport/Mode.set_text(text_dict[type])
	$Mesh.mesh.surface_set_material(0, get_material(type))

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		var text_dict = {
			0 : "Square",
			1 : "Triangle",
			2 : "Circle"
		}
		$Label3D/TextViewport/Mode.set_text(text_dict[type])
		$Mesh.mesh.surface_set_material(0, get_material(type))
	else:
		$Label3D.translation = self.transform.basis.transposed() * Vector3.UP

func get_material(type):
	match type:
		0:
			return RED
		1:
			return GREEN
		2:
			return YELLOW

func _set(property: String, value) -> bool:
	var return_value = true
	match property:
		"general/type":
			type = value
		_:
			return_value = false
	return return_value
	
func _get(property: String):
	match property:
		"general/type":
			return type
	
func _get_property_list() -> Array:
	var p = []
	
	p.append({
		name = "general/type",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "Square,Triangle,Circle"
	})
	
	return p
