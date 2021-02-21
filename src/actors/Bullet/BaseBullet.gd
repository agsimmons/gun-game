extends KinematicBody2D

export (Resource) var bullet_impact_effect

var velocity

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var impact_effect = bullet_impact_effect.instance()
		impact_effect.global_position = global_position
		impact_effect.emitting = true
		get_tree().get_root().add_child(impact_effect)
		queue_free()
