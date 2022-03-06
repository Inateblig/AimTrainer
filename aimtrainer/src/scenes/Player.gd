extends KinematicBody

signal fire

const MOUSE_SENS: float = 0.125
const MOVE_SPEED: float = 10.0
const GRAVITY_ACC: float = 9.8 * 3
const JUMP_FORCE: float = 10.0
const MAX_JUMPS: int = 2

var jumps: int = 1

onready var head: Spatial = $Head
onready var raycast: RayCast = $Head/Camera/RayCast

var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()
var snap_vector: Vector3 = Vector3()

func _ready():

	$Head/Camera/laserV2/lasershot.visible = false


func _input(event):
	if event is InputEventMouseMotion and !Globals.pause:
		rotate_y(deg2rad(-1 * event.relative.x) * MOUSE_SENS)
		head.rotate_x(deg2rad(event.relative.y) * MOUSE_SENS)


func _physics_process(delta):
	input_move = get_input_direction() * MOVE_SPEED
	
	if not is_on_floor():
		gravity_local += GRAVITY_ACC * Vector3.DOWN * delta
	else:
		gravity_local = Vector3.ZERO

	snap_vector = Vector3.DOWN
	if is_on_floor():
		snap_vector = -get_floor_normal()

	if Input.is_action_just_pressed("jump") and jumps < MAX_JUMPS:
		snap_vector = Vector3.ZERO
		gravity_local = Vector3.UP * JUMP_FORCE
		jumps += 1
	if is_on_floor():
		jumps = 1
	move_and_slide_with_snap(input_move + gravity_local, snap_vector, Vector3.UP)
	fire()



func get_input_direction() -> Vector3:
	var z: float = (
		Input.get_action_strength("fwd") - Input.get_action_strength("bwd")
	)
	var x: float = (
		Input.get_action_strength("left") - Input.get_action_strength("right")
	)
	return transform.basis.xform(Vector3(x, 0, z).normalized())


func fire():
	if Input.is_action_just_pressed("fire") and !Globals.pause:
		emit_signal("fire")
		$AnimationPlayer.play("fire")
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if target.is_in_group("target"):
				target.health -= Globals.dmg
