extends Area2D

export (Resource) var bullet_impact_effect

var velocity

func _physics_process(delta):
	self.position += velocity * delta


func _on_BaseBullet_body_entered(body):
	if body.is_in_group("object"):
		body.destroy()

	if body.is_in_group("object") or body.is_in_group("wall"):
		var impact_effect = bullet_impact_effect.instance()
		impact_effect.global_position = global_position
		impact_effect.emitting = true
		get_tree().get_root().add_child(impact_effect)
		queue_free()
