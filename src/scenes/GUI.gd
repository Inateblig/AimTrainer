extends CanvasLayer

var zoom_val: int = 50
var prev_fov: float = 80

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				$VBoxContainer/FOV/HSlider.value -= 2
			elif event.button_index == BUTTON_WHEEL_DOWN:
				$VBoxContainer/FOV/HSlider.value += 2


func _process(_delta):
	zoom()
	#GUI
	var fov: float = $VBoxContainer/FOV/HSlider.value
	var laser: bool = $VBoxContainer/Laser/CheckBox.pressed
	var xrange: float = $VBoxContainer/RandRange/XSlider.value
	var yrange: float = $VBoxContainer/RandRange/YSlider.value
	var zrange: float = $VBoxContainer/RandRange/ZSlider.value
	var dmg: float = $VBoxContainer/Dmg/HSlider.value
	var size: float = $VBoxContainer/Size/HSlider.value
	var tee: bool = $VBoxContainer/Tee/CheckBox.pressed
	var ntargets: int = $VBoxContainer/NTargets/HSlider.value
	$VBoxContainer/FOV/Label.set_text("FOV: " + str(fov))
	$VBoxContainer/Laser/Label.set_text("LaserModel: " + str(laser))
	$VBoxContainer/RandRange/X.set_text("X: " + str(xrange))
	$VBoxContainer/RandRange/Y.set_text("Y: " + str(yrange))
	$VBoxContainer/RandRange/Z.set_text("Z: " + str(zrange))
	$VBoxContainer/Dmg/Label.set_text("Dmg: " + str(dmg))
	$VBoxContainer/Size/Label.set_text("Size: " + str(size))
	$VBoxContainer/Tee/Label.set_text("TeeModel: " + str(tee))
	$VBoxContainer/NTargets/Label.set_text("NumberOfTargets: " + str(ntargets))
	Globals.fov = fov
	Globals.laser = laser
	Globals.randrange = Vector3(xrange, yrange, zrange)
	Globals.dmg = dmg
	Globals.size = size
	Globals.tee = tee
	Globals.ntargets = ntargets

func zoom():
	if Input.is_action_just_pressed("zoom_in"):
		prev_fov = Globals.fov
		$VBoxContainer/FOV/HSlider.value =  Globals.fov - zoom_val
	elif Input.is_action_just_released("zoom_in"):
		$VBoxContainer/FOV/HSlider.value = prev_fov
