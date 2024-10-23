extends Label

var _score = 0

func _ready():
	text = str(floor(Stats.score))

func _process(delta):
	if !Global.level_finished:
		text = str(floor(Stats.score))
		_score = Stats.score
	elif _score < Stats.score:
		text = str(floor(_score))
		_score += 10
	else:
		await get_tree().create_timer(1.0).timeout
		Global.move_to_next_level = true
