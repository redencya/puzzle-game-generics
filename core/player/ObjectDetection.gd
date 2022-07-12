extends RayCast

var current_body : Cube = null
onready var pivot = $PinJoint

signal highlight_object(value)

var hold_mode: bool = false

func _ready() -> void:
	print(pivot.get_node_b())

func _process(delta: float) -> void:
	emit_signal("highlight_object", get_collider())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup"):
		if get_collider() is Cube && !hold_mode:
			$Pickup.play()
			current_body = get_collider()
			hold_mode = true
			current_body.collision_mask = 7
			current_body.collision_layer = 4
			$RigidBody.collision_mask = 32
			pivot.set_node_b(current_body.get_path())
			current_body.set_total_angular_axis_lock(true)
		elif hold_mode:
			current_body.collision_mask = 15
			current_body.collision_layer = 2
			$RigidBody.collision_mask = 0
			pivot.set_node_b("")
			current_body.set_total_angular_axis_lock(false)
			current_body = null
			hold_mode = false
			$Drop.play()
