extends KinematicBody

var i = 0

onready var ray = $Camera/RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
			var l = lerp(Vector2.ZERO, event.relative * Settings.mouse_speed, 0.75)
			self.rotate_y(-l.x)
			$Camera.rotate_x(l.y)

func _physics_process(dt):
	if Input.is_action_just_pressed("fire"):
		fire()

func fire():
	if ray.is_colliding():
		var cldr = ray.get_collider()
		if cldr.is_in_group("target"):
			cldr.update_hp(-Variables.dmg)
