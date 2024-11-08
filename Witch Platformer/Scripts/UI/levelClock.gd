extends Label

var time_left := 200.0
# You don't really need this
var counter = 1
var is_stopped := false

func _process(delta: float) -> void:
	if !is_stopped:
		if Global.level_finished:
			Stats.score += time_left * 10
			MusicAudio.levelFinished.emit()
			stop()
			return
		
		if time_left > 0:
			time_left -= delta
		else:
			MusicAudio.levelFinished.emit()
			stop()
			return
		
		if time_left <= 50.5:
			modulate = Color.RED
		elif time_left <= 100.5:
			modulate = Color.YELLOW
		
		text = str(roundi(time_left))

func reset() -> void:
	time_left = 0.0
	is_stopped = false

func stop() -> void:
	is_stopped = true
