extends Area

var hp = Variables.hitpoints
var offset: Vector3 = Vector3.ZERO

func _ready():
	offset = global_transform.origin
	update_pos()

func update_hp(health: float):
	hp += health
	if hp <= 0:
		respawn()

func respawn():
	update_pos()
	update_hp(Variables.hitpoints)

func update_pos():
	var pos: Vector3 = Vector3.ZERO
	pos.x = randf() * Settings.spawn_range.x
	pos.y = randf() * Settings.spawn_range.y
	pos.z = randf() * Settings.spawn_range.z
	self.global_transform.origin = pos + offset
	
