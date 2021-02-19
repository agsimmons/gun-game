extends KinematicBody2D

const FRICTION = 0.5
const AIR_RESISTANCE = 0.01
const MAX_SPEED = 400
const GRAVITY = 600
const AIR_MANEUVERABILITY = 100

var velocity = Vector2.ZERO
var shot_fired = false
var mouse_position = Vector2.ZERO

onready var Gun = $Gun


func _unhandled_input(event):
	mouse_position = get_global_mouse_position()

	Gun.rotate(Gun.get_angle_to(mouse_position))

	if event.is_action_pressed("click"):
		shot_fired = true


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if is_on_floor():
		# Reload Gun
		Gun.reload()

		# Apply Friction
		velocity.x = lerp(velocity.x, 0, FRICTION)
	else:
		# Apply Gravity
		velocity.y += GRAVITY * delta

		# Apply Horizontal Air Movement
		velocity.x += x_input * AIR_MANEUVERABILITY * delta

		# Apply Air Resistance
		velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
		velocity.y = lerp(velocity.y, 0, AIR_RESISTANCE)

	if shot_fired:
		if Gun.ammo > 0:
			var shot_force_vector = mouse_position.direction_to(position)
			var dampening = (cos(shot_force_vector.angle_to(velocity)) + 1) / 2
			velocity *= dampening
			velocity += shot_force_vector * Gun.shot_force
			Gun.shoot()
		else:
			# This is just to trigger the dry-fire sound effect. There is
			# probably a better way to format this code
			Gun.shoot()
		shot_fired = false

	# Clamp Velocity
	var speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
	if speed > MAX_SPEED:
		var velocity_scale = MAX_SPEED / speed
		velocity.x *= velocity_scale
		velocity.y *= velocity_scale

	velocity = move_and_slide(velocity, Vector2.UP)
