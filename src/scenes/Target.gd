extends KinematicBody

signal hit

export var health = 100
var size: Vector3 = self.scale
var phealth = 100
var healthchanged: bool = false
onready var sizex: float = $MeshInstance.scale.x
var soundfilepath = "res://src/assets/sounds/respawn/vo_teefault_spawn-0"

func _ready():
	randomize()

func _process(_delta):
	if !healthchanged:
		update_size()
	if health < phealth:
		emit_signal("hit")
		if health > 25:
			self.scale = self.scale * health / 100
			healthchanged = true
	if health <= 0:
		respawn()
		healthchanged = false
	phealth = health
	# whether to show the tee model
	tee(Globals.tee)

func respawn():
	health = 100
	var tries = 0
	while true:
		var target_pos = random_pos()
		print("printoif")
		if (Globals.player_pos - target_pos).length() > 5:
			self.translation = target_pos
			break
		tries += 1
		if tries >= 4:
			print("gtfo")
			break
	update_size()
	$AudioStreamPlayer3D.stream\
	= load(Globals.set_audio_file(soundfilepath, 7))
	$AudioStreamPlayer3D.play()

func random_pos():
	var rx = randi() % int(Globals.randrange.x) - Globals.randrange.x / 2
	var ry = randi() % int(Globals.randrange.y)
	var rz = randi() % int(Globals.randrange.z)
	var rvec3 = Vector3(rx , ry + 1.5 + Globals.size / 100, rz)
	return rvec3

func update_size():
	self.scale = size * Globals.size / 100

func tee(on):
	$tee2.visible = on
	$MeshInstance.visible = !on
