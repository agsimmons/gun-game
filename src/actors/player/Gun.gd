extends Node2D

signal shot_fired
signal reloaded

export var ammo_capacity = 2
export var shot_force = 400
export (Resource) var gunshot_effect
export (Resource) var dry_fire_effect
export (Resource) var reload_effect

var ammo = 0

var gunshot_player
var dry_fire_player
var reload_player

onready var BulletSpawnPosition = $BulletSpawnPosition


func _ready():
	# Initialize Ammo to Full
	ammo = ammo_capacity

	gunshot_player = AudioStreamPlayer.new()
	gunshot_player.stream = gunshot_effect
	self.add_child(gunshot_player)

	dry_fire_player = AudioStreamPlayer.new()
	dry_fire_player.stream = dry_fire_effect
	self.add_child(dry_fire_player)

	reload_player = AudioStreamPlayer.new()
	reload_player.stream = reload_effect
	self.add_child(reload_player)


func shoot():
	if ammo > 0:
		emit_signal("shot_fired")
		self.gunshot_player.play()
		ammo -= 1
	else:
		self.dry_fire_player.play()


func reload():
	if ammo < ammo_capacity:
		emit_signal("reloaded")
		ammo = ammo_capacity
		self.reload_player.play()
