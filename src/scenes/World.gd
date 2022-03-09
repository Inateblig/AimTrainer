extends Spatial

var hits: int = 0
var tries: int = 0
var time: float = 0.0
var acct: float = 0.0
var save_path = "user://save.dat"

func _ready():
	acct = load_time_from_file()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_time_to_file()
		get_tree().quit()

func _physics_process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	# pause logic
	Globals.pause = Input.is_action_just_pressed("pause") != Globals.pause
	if Globals.pause:
		visibility_hud_and_menu(false)
	else:
		visibility_hud_and_menu(true)
		time += delta
		# acct
		acct += delta
		var accts = int(acct) % 60
		var acctm = int(acct / 60) % 60
		var accth = int(acct / 3600)
		$HUD/HBoxContainer/acct.set_text\
			("TotalTimePlayed: " + str(accth) + "h " + str(acctm) + "m " + str(accts) + "s")
		# HUD
		$HUD/FPS.set_text("fps: " + str(Engine.get_frames_per_second()))
		$HUD/HBoxContainer/Score.set_text("Score: " + str(hits / time * 100).pad_decimals(0) + " ")

func _on_Player_hit():
	hits += 1
	print(hits)

func _on_Player_fire():
	tries += 1
	$HUD/HBoxContainer/Accuracy.set_text\
		("Acc: " + str(float(hits) / tries * 100).pad_decimals(2) + "% ")

var pvis: bool = !Globals.pause
func visibility_hud_and_menu(on):
	if on == pvis:
		return
	pvis = on
	$HUD.visible = on
	$GUI/VBoxContainer.visible = !on
	if !on:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func save_time_to_file():
	var file = File.new()
	if file.open(save_path, File.WRITE) == OK:
		print(acct)
		file.store_string(str(acct))
		file.close()

func load_time_from_file():
	var file = File.new()
	if file.file_exists(save_path): 
		if file.open(save_path, File.READ) == OK:
			var acct = file.get_line()
			file.close()
			return float(acct)
	return 0.0
