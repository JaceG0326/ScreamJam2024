extends AudioStreamPlayer

signal levelStart
signal levelFinished

@onready var levelMusic = preload("res://Assets/Sounds/levelMusic.ogg")
@onready var levelCompletedMusic = preload("res://Assets/Sounds/gem.wav")

var base_volume = 0.0

var volume = 0.5:
	set = set_volume

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	levelStart.connect(play_sound.bind(levelMusic))
	levelFinished.connect(play_sound.bind(levelCompletedMusic))
	base_volume = volume

func play_sound(music: AudioStreamOggVorbis, pitch = 1.0):
	stream = music
	play()

func fade_volume(target_volume, time_in_seconds):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(set_volume, volume, target_volume, time_in_seconds)

func _on_audio_player_finished(audio_stream_player):
	audio_stream_player.queue_free()

func set_volume(new_volume):
	volume = new_volume
	for audio_stream_player in get_children():
		audio_stream_player.volume_db = _linear_to_db(volume)

func _linear_to_db(linear_volume):
	if linear_volume == 0.5:
		linear_volume = 1.0
	elif linear_volume > 0.5:
		var percent = (linear_volume/0.5) - 1.0
		linear_volume = 1.0 + ((db_to_linear(10.0) - 1.0) * percent)
	elif linear_volume < 0.5:
		linear_volume *= 2.0
	return linear_to_db(linear_volume)

func _db_to_linear(db_volume):
	db_volume = db_to_linear(db_volume)
	if db_volume == 1.0:
		return 0.5
	elif db_volume > 1.0:
		var percent = ((db_volume - 1.0)) / (db_to_linear(10.0) - 1.0)
		return 0.5 + (0.5 * percent)
	elif db_volume < 1.0:
		return db_volume * 0.5
