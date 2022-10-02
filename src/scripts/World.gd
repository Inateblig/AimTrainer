extends Spatial

var trgt = preload("res://src/scenes/Target.tscn")

func _init():
	randomize()

func _ready():
	for i in range(Settings.n_targets):
		$Position3D.add_child(trgt.instance())
	
