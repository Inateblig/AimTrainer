extends CanvasLayer

func _process(_delta):
	#GUI
	var fov: float = $VBoxContainer/FOV/HSlider.value
	var laser: bool = $VBoxContainer/Laser/CheckBox.pressed
	var xrange: float = $VBoxContainer/RandRange/XSlider.value
	var yrange: float = $VBoxContainer/RandRange/YSlider.value
	var zrange: float = $VBoxContainer/RandRange/ZSlider.value
	var dmg: float = $VBoxContainer/Dmg/HSlider.value
	var size: float = $VBoxContainer/Size/HSlider.value
	var tee: bool = $VBoxContainer/Tee/CheckBox.pressed
	$VBoxContainer/FOV/Label.set_text("FOV: " + str(fov))
	$VBoxContainer/Laser/Label.set_text("LaserModel: " + str(laser))
	$VBoxContainer/RandRange/X.set_text("X: " + str(xrange))
	$VBoxContainer/RandRange/Y.set_text("Y: " + str(yrange))
	$VBoxContainer/RandRange/Z.set_text("Z: " + str(zrange))
	$VBoxContainer/Dmg/Label.set_text("Dmg: " + str(dmg))
	$VBoxContainer/Size/Label.set_text("Size: " + str(size))
	$VBoxContainer/Tee/Label.set_text("TeeModel: " + str(tee))
	Globals.fov = fov
	Globals.laser = laser
	Globals.randrange = Vector3(xrange, yrange, zrange)
	Globals.dmg = dmg
	Globals.size = size
	Globals.tee = tee
