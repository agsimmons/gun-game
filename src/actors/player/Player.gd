extends KinematicBody2D

const AIR_MANEUVERABILITY = 100
const MAX_SPEED = 300
const FRICTION = 0.5
const AIR_RESISTANCE = 0.01
const GRAVITY = 600
const SHOT_FORCE = 400
const PEAK_TIMESLOW_THRESHOLD = 10
const PEAK_TIMESLOW_AMT = 0.1

var velocity = Vector2.ZERO
var shot_fired = false
var mouse_position = Vector2.ZERO
var dampening_mode = 2

const DEFAULT_NUM_BULLETS = 2
var num_bullets = DEFAULT_NUM_BULLETS

onready var Gun = $Gun
onready var SoundGunshot = $SoundGunshot
onready var SoundReload = $SoundReload
onready var SoundDryFire = $SoundDryFire

func _unhandled_input(event):
	mouse_position = get_global_mouse_position()
	
	Gun.rotate(Gun.get_angle_to(mouse_position))
	
	if event.is_action_pressed("click"):
		shot_fired = true


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if is_on_floor():
		if num_bullets < DEFAULT_NUM_BULLETS:
			# Reload Bullets
			SoundReload.play()
			num_bullets = DEFAULT_NUM_BULLETS
		
		# Apply Friction
		velocity.x = lerp(velocity.x, 0, FRICTION)
	else:
		# Apply Gravity
		if(abs(velocity.y) < PEAK_TIMESLOW_THRESHOLD):
			velocity.y += GRAVITY * delta * PEAK_TIMESLOW_AMT
		else:
			velocity.y += GRAVITY * delta 
		
		# Apply Horizontal Air Movement
		velocity.x += x_input * AIR_MANEUVERABILITY * delta
		
		# Apply Air Resistance
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
		velocity.y = lerp(velocity.y, 0, AIR_RESISTANCE)
		
	if shot_fired:
		if num_bullets > 0:
			var shot_force_vector = mouse_position.direction_to(position)
			if dampening_mode == 1:
				if !is_on_floor():
					'var xDampening = 1 - (abs(shot_force_vector.normalized().x - velocity.normalized().x)/2)'
					var yDampening = 1 - (abs(shot_force_vector.normalized().y - velocity.normalized().y)/2)
					'velocity.x*=xDampening'
					velocity.y*=yDampening
			else: if dampening_mode == 2:
				if !is_on_floor():
					var xDampening = 1 - (abs(shot_force_vector.normalized().x - velocity.normalized().x)/2)
					var yDampening = 1 - (abs(shot_force_vector.normalized().y - velocity.normalized().y)/2)
					velocity.x*=xDampening
					velocity.y*=yDampening
			else:			
				var dampening = (cos(shot_force_vector.angle_to(velocity)) + 1) / 2
				velocity *= dampening
				
			velocity += shot_force_vector * SHOT_FORCE
			SoundGunshot.play()
			#Gun.shoot(shot_force_vector)
			num_bullets -= 1
		else:
			SoundDryFire.play()
		shot_fired = false
		
	#velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	#velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	velocity = move_and_slide(velocity, Vector2.UP)

