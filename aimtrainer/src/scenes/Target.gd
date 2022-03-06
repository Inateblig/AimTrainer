extends KinematicBody

signal hit

export var health = 100
var size: Vector3 = Vector3.ZERO
var phealth = 100
onready var sizex: float = $MeshInstance.scale.x

func _ready():
	randomize()

func _process(_delta):
	if health < phealth:
		emit_signal("hit")
		if health > 25:
			self.scale = self.scale * health / 100
	if health <= 0:
		respawn()
	phealth = health

func respawn():
	var rx = randi() % int(Globals.randrange.x) - Globals.randrange.x / 2
	var ry = randi() % int(Globals.randrange.y)
	var rz = randi() % int(Globals.randrange.z)
	var rvec3 = Vector3(rx , ry + 2.5, rz)
	self.translation = rvec3
	self.scale = Vector3(1, 1, 1)
	health = 100
