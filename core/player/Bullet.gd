extends Spatial
class_name Bullet

signal hit

export var muzzle_velocity = 25 # m/s
export var error_halftime = 0.1 # s

var lifetime = 5.0 # s
var error = Vector3.ZERO

onready var Particles = $Particles
onready var RayCast = $RayCast
onready var AnimationPlayer = $AnimationPlayer

func _ready():
	RayCast.cast_to = Vector3.FORWARD * muzzle_velocity / Engine.iterations_per_second

func _process(delta):
	if RayCast.enabled:
		translate(Vector3.FORWARD * muzzle_velocity * delta)
		var fix_error = error * delta / error_halftime
		translate(fix_error)
		error -= fix_error
	
	if lifetime <= 0.0:
		queue_free()
	
	if muzzle_velocity > 0 and RayCast.is_colliding():
		object_hit(RayCast.get_collider())
		translation = RayCast.get_collision_point()
		RayCast.enabled = false
		AnimationPlayer.play("HitAnimation")
		lifetime = AnimationPlayer.current_animation_length


func object_hit(body: Node) -> void:
	emit_signal("hit", transform.origin)
	if body is Cube:
		PowerManager.power_object(body)

func init(muzzle_transform : Transform, player: Vector3):
	transform = muzzle_transform
	error = transform.inverse() * player
