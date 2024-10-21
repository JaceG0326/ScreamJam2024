extends Area2D

func _on_body_entered(body):
	if body is Witch:
		body.is_dead = true
	else:
		body.queue_free()
