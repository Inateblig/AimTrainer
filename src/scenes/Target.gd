extends KinematicBody

signal hit

export var health = 100
var size: Vector3 = self.scale
var phealth = 100
var healthchanged: bool = false
onready var sizex: float = $MeshInstance.scale.x

func _ready():
	randomize()

func _process(_delta):
	if !healthchanged:
		self.scale = size * Globals.size / 100
	if health < phealth:
		emit_signal("hit")
		if health > 25:
			self.scale = self.scale * health / 100
			healthchanged = true
	if health <= 0:
		respawn()
	phealth = health
#wether to show the tee model
	if Globals.tee:
		tee(true)
	else:
		tee(false)

func respawn():
	var rx = randi() % int(Globals.randrange.x) - Globals.randrange.x / 2
	var ry = randi() % int(Globals.randrange.y)
	var rz = randi() % int(Globals.randrange.z)
	var rvec3 = Vector3(rx , ry + 1.5 + Globals.size / 100, rz)
	self.translation = rvec3
	self.scale = size * Globals.size / 100
	health = 100

func tee(on):
	$tee2.visible = on
	$MeshInstance.visible = !on
