extends Node

var pause: bool = true
var randrange: Vector3 = Vector3(0, 0, 0)
var dmg: float = 100
var laser: bool = false
var fov: float = 80
var size: float = 100
var tee: bool = false

func set_audio_file(filepath, files):
	var i = randi() % files + 1
	var file = filepath + str(i) + ".ogg"
	return file
