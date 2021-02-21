extends Node2D

signal shot_fired
signal reloaded

export var ammo_capacity = 2
export var shot_force = 400
export var shot_speed = 800
export (Resource) var bullet_type
export (AudioStream) var gunshot_effect
export (AudioStream) var dry_fire_effect
export (AudioStream) var reload_effect
export (Resource) var gunshot_particle_effect

var ammo = 0

var gunshot_player
var dry_fire_player
var reload_player

onready var GunStartPosition = $GunStartPosition
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
		var shot_direction = GunStartPosition.global_position.direction_to(BulletSpawnPosition.global_position)

		# Spawn Bullet
		var bullet = bullet_type.instance()
		bullet.position = BulletSpawnPosition.global_position
		bullet.rotation = BulletSpawnPosition.global_rotation
		bullet.velocity = shot_direction * shot_speed
		get_tree().get_root().add_child(bullet)
		
		# Spawn Shot Effect
		var particle_instance = gunshot_particle_effect.instance()
		particle_instance.global_position = BulletSpawnPosition.global_position
		particle_instance.rotation = BulletSpawnPosition.global_rotation
		particle_instance.emitting = true
		get_tree().get_root().add_child(particle_instance)
		
		ammo -= 1
		self.gunshot_player.play()

		emit_signal("shot_fired")
	else:
		self.dry_fire_player.play()


func reload():
	if ammo < ammo_capacity:
		emit_signal("reloaded")
		ammo = ammo_capacity
		self.reload_player.play()
