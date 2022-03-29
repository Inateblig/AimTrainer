extends KinematicBody

var health = 100
var psize = Globals.size
var healthchanged: bool = false
var soundfilepath = "res://src/assets/sounds/respawn/vo_teefault_spawn-0"
var target2close = false

func _ready():
	respawn(false)

func _process(_delta):
	if psize != Globals.size:
		update_size()
	if healthchanged:
		healthchanged = false
		if health > 25:
			update_size()
		elif health <= 0:
			respawn(true)
	psize = Globals.size
	is_tee_visible(Globals.tee)

func respawn(sound):
	health = 100
	var tries = 0
	while true:
		var respawn_pos = random_pos()
		if (Globals.player_pos - respawn_pos).length() > 5 or target2close:
			self.translation = respawn_pos
			break
		tries += 1
		if tries >= 10:
			break
	update_size()
	if sound:
		$AudioStreamPlayer3D.stream\
			= load(Globals.set_audio_file(soundfilepath, 7))
		$AudioStreamPlayer3D.play()

func random_pos() -> Vector3:
	var rx = randi() % int(Globals.randrange.x) - Globals.randrange.x / 2
	var ry = randi() % int(Globals.randrange.y)
	var rz = randi() % int(Globals.randrange.z)
	return Vector3(rx , ry + Globals.size / 100, rz)

func update_size():
	self.scale = Vector3(1, 1, 1) * health / 100 * Globals.size / 100

func is_tee_visible(on):
	$tee2.visible = on
	$MeshInstance.visible = !on


func _on_Area_body_entered(body):
	if body != self && body.is_in_group("target"):
		target2close = true


func _on_Area_body_exited(body):
	if body != self && body.is_in_group("target"):
		target2close = false
