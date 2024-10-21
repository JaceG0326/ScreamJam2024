extends Label

var _score = 0

func _ready():
	text = str(Stats.score)

func _process(delta):
	if !Global.level_finished:
		text = str(Stats.score)
		_score = Stats.score
	elif _score < Stats.score:
		text = str(floor(_score))
		_score += 10
