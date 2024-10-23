extends Node2D

func _on_area_body_entered(body):
	if Global.platforming_player:
		Global.platforming_player.set_collision_mask_value(3, false)

func _on_area_body_exited(body):
	if Global.platforming_player:
		Global.platforming_player.set_collision_mask_value(3, true)
