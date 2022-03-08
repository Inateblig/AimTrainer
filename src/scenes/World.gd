extends Spatial

var score: float = 1.0
var tries: float = 0.0
var time: float = 0.001
var acct: float = 0.0
var save_path = "user://save.dat"
var file = File.new()

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
		save_time_to_file(delta)
	#HUD
	$HUD/FPS.set_text("fps: " + str(Engine.get_frames_per_second()))
	$HUD/HBoxContainer/Score.set_text("Score: " + str(score / time * 100).pad_decimals(0) + " ")
	#acct
	var acct = load_time_from_file()
	var accts = int(acct) % 60
	var acctm = int(acct / 60)
	var accth = int(acct / 3600)
	$HUD/HBoxContainer/acct.set_text("TotalTimePlayed: " + str(accth) + "h " + str(acctm) + "m " + str(accts) + "s")

func _on_Target_hit():
	if !Globals.pause:
		score += 1.0

func _on_Player_fire():
	fire()

func fire():
	tries += 1.0
	$HUD/HBoxContainer/Accuracy.set_text("Acc: " + str(score / tries * 100).pad_decimals(2) + "% ")

func visibility_hud(on):
	$HUD.visible = on

func visibility_menu(on):
	$GUI/VBoxContainer.visible = on

func save_time_to_file(delta):
	var acct = load_time_from_file()
	if acct == null:
		acct = 0.0
	acct += delta
	if file.open(save_path, File.WRITE) == OK:
		file.store_string(str(acct))
		file.close()

func load_time_from_file():
	if file.file_exists(save_path): 
		if file.open(save_path, File.READ) == OK:
			var acct = file.get_line()
			file.close()
			return float(acct)
	elif !file.file_exists(save_path):
		var acct = 0.0
		if file.open(save_path, File.WRITE) == OK:
			file.store_string(str(acct))
			file.close()
			return acct
	return 0.0
