extends KinematicBody2D

const FRICTION = 0.5
const AIR_RESISTANCE = 0.01
const MAX_SPEED = 400
const GRAVITY = 600
const AIR_MANEUVERABILITY = 100

var velocity = Vector2.ZERO
var mouse_position = Vector2.ZERO
var shot_events = []

onready var Gun = $Gun


func _unhandled_input(event):
	mouse_position = get_global_mouse_position()

	Gun.rotate(Gun.get_angle_to(mouse_position))

	if event.is_action_pressed("click"):
		Gun.shoot()


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if is_on_floor():
		if shot_events.empty():
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

	# Handle Shot Events
	while !shot_events.empty():
		var shot_event_force = shot_events.pop_front()
		var shot_force_vector = mouse_position.direction_to(position)
		var dampening = (cos(shot_force_vector.angle_to(velocity)) + 1) / 2
		velocity *= dampening
		velocity += shot_force_vector * shot_event_force

	# Clamp Velocity
	var speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
	if speed > MAX_SPEED:
		var velocity_scale = MAX_SPEED / speed
		velocity.x *= velocity_scale
		velocity.y *= velocity_scale

	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Gun_shot_fired():
	shot_events.append(Gun.shot_force)
