extends Node2D

#onready var BulletSpawnPosition = $BulletSpawnPosition

export var ammo_capacity = 2
export var shot_force = 400
export (Resource) var gunshot_effect
export (Resource) var dry_fire_effect
export (Resource) var reload_effect

var ammo = 0

var gunshot_player
var dry_fire_player
var reload_player


func _ready():
	# Initialize Ammo to Full
	ammo = ammo_capacity

	gunshot_player = AudioStreamPlayer.new()
	# gunshot_player.stream = gunshot_effect
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
		self.gunshot_player.play()
		ammo -= 1
		print("Shot Fired")
		print("Remaining Ammo: " + str(ammo))
	else:
		self.dry_fire_player.play()
		print("Dry Fire!")


func reload():
	if ammo < ammo_capacity:
		print("Reloading...")
		ammo = ammo_capacity
		self.reload_player.play()
