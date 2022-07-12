extends Spatial
tool 

export var state : bool = false setget set_state, get_state

var material_on  = load("res://assets/catcher_on.material")
var material_off = load("res://assets/catcher_off.material")

func _ready():
	_fix_gravity()
	set_state(state)

func set_state(value: bool):
	state = value
	$Bullet.visible = value
	$Particles.emitting = value
	$Catcher.material_override = material_on if value else material_off

func get_state():
	return state

func _enter_tree() -> void:
	set_notify_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_fix_gravity()

func _fix_gravity():
	$Particles.transform.basis = global_transform.basis.transposed()
	$Particles.direction = global_transform.basis * Vector3.UP
