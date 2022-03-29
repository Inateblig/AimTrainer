extends KinematicBody

signal fire
signal hit

const MOUSE_SENS: float = 0.005
const MOVE_SPEED: float = 10.0
const GRAVITY_ACC: float = 9.8 * 3
const JUMP_FORCE: float = 10.0
const MAX_JUMPS: int = 2

var jumps: int = 0

onready var head: Spatial = $Head
onready var raycast: RayCast = $Head/Camera/RayCast

var input_move: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()
var snap_vector: Vector3 = Vector3()

var soundfilepath = "res://src/assets/sounds/laser_fire/wp_laser_fire-0"

func _input(event):
	if event is InputEventMouseMotion and !Globals.pause:
		self.rotate_y((-event.relative.x) * MOUSE_SENS)
		head.rotate_x((event.relative.y) * MOUSE_SENS)

func _physics_process(delta):
	if !Globals.pause:
		input_move = get_input_direction() * MOVE_SPEED
	
		if !is_on_floor():
			gravity_local += GRAVITY_ACC * Vector3.DOWN * delta
		else:
			snap_vector = -get_floor_normal()
			gravity_local = Vector3.ZERO
			jumps = 0

		if Input.is_action_just_pressed("jump") and jumps < MAX_JUMPS:
			snap_vector = Vector3.ZERO
			gravity_local = Vector3.UP * JUMP_FORCE
			jumps += 1
		move_and_slide_with_snap(input_move + gravity_local, snap_vector, Vector3.UP)
		if Input.is_action_just_pressed("fire"):
			fire()
	# GUI
	$Head/Camera.fov = Globals.fov
	$ViewportContainer/Viewport/laserV2.visible = Globals.laser
	# get player_pos
	Globals.player_pos = $CollisionShape/MeshInstance.global_transform.origin

func get_input_direction() -> Vector3:
	var z: float = (
		Input.get_action_strength("fwd") - Input.get_action_strength("bwd")
	)
	var x: float = (
		Input.get_action_strength("left") - Input.get_action_strength("right")
	)
	return transform.basis.xform(Vector3(x, 0, z).normalized())

func fire():
		$AnimationPlayer.play("fire")
		$Head/Camera/AudioStreamPlayer3D.stream\
			= load(Globals.set_audio_file(soundfilepath, 3))
		$Head/Camera/AudioStreamPlayer3D.play()
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if target.is_in_group("target"):
				target.health -= Globals.dmg
				target.healthchanged = true
				emit_signal("hit")
		emit_signal("fire")
