extends Node

func _ready():
	var level = Global.levels[Global.current_level_id].instantiate()
	add_child(level)

func _process(delta):
	if Global.move_to_next_level:
		Stats.high_score = max(Stats.high_score, Stats.score)
		Stats.score = 0
		_next_level()

func _next_level():
	Global.current_level_id += 1
	if Global.levels.size() > Global.current_level_id:
		Global.level_finished = false
		Global.move_to_next_level = false
		Global.platforming_player = null
		Global.player_camera = null
		get_tree().reload_current_scene()
	return

func _on_quit_pressed():
	get_tree().quit()
