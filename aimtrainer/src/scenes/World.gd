extends Spatial

var score: float = 0.0
var tries: float = 0.0
var time: float = 0.001

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	#pause logic
	if Input.is_action_just_pressed("pause") and !Globals.pause:
		Globals.pause = true
	elif Input.is_action_just_pressed("pause") and Globals.pause:
		Globals.pause = false
	if Globals.pause:
		visibility_hud(false)
		visibility_menu(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		visibility_menu(false)
		visibility_hud(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		time += delta
	#HUD
	$VBoxContainer/FPS.set_text("fps: " + str(Engine.get_frames_per_second()))
	$VBoxContainer/HBoxContainer/Score.set_text("Score: " + str(score / time * 100).pad_decimals(0))
	#GUI
	var fov: float = $GUI/VBoxContainer/FOV/HSlider.value
	var laser: bool = $GUI/VBoxContainer/Laser/CheckBox.pressed
	var xrange: float = $GUI/VBoxContainer/RandRange/XSlider.value
	var yrange: float = $GUI/VBoxContainer/RandRange/YSlider.value
	var zrange: float = $GUI/VBoxContainer/RandRange/ZSlider.value
	var dmg: float = $GUI/VBoxContainer/Dmg/HSlider.value
	$GUI/VBoxContainer/FOV/Label.set_text("FOV: " + str(fov))
	$GUI/VBoxContainer/Laser/Label.set_text("LaserModel: " + str(laser))
	$GUI/VBoxContainer/RandRange/X.set_text("X: " + str(xrange))
	$GUI/VBoxContainer/RandRange/Y.set_text("Y: " + str(yrange))
	$GUI/VBoxContainer/RandRange/Z.set_text("Z: " + str(zrange))
	$GUI/VBoxContainer/Dmg/Label.set_text("Dmg: " + str(dmg))
	$Player/Head/Camera.fov = fov
	$Player/Head/Camera/laserV2.visible = laser
	Globals.randrange = Vector3(xrange, yrange, zrange)
	Globals.dmg = dmg



func _on_Target_hit():
	if !Globals.pause:
		score += 1.0

func _on_Player_fire():
	fire()


func fire():
	tries += 1.0
	$VBoxContainer/HBoxContainer/Accuracy.set_text("Acc: " + str(score / tries * 100).pad_decimals(2) + "%")

func visibility_hud(on):
	$VBoxContainer.visible = on

func visibility_menu(on):
	$GUI/VBoxContainer.visible = on
