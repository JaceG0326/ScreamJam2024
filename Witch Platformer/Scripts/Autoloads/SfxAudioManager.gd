extends Node

signal skeletonHurt
signal playerHurt
signal fragmentCollected
signal chargingSpell
signal finishedCharging

@onready var skeletonHurtSound = preload("res://Assets/Sounds/hurt3_monster.wav")
@onready var playerHurtSound = preload("res://Assets/Sounds/gem.wav")
@onready var collectFragmentSound = preload("res://Assets/Sounds/gem.wav")
@onready var chargeSpell = preload("res://Assets/Sounds/magic-spell-1-232441.wav")
@onready var releaseSpell = preload("res://Assets/Sounds/magic-spell-6005.wav")

var base_volume = 0.0

var volume = 0.5:
	set = set_volume

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	skeletonHurt.connect(play_sound.bind(skeletonHurtSound))
	playerHurt.connect(play_sound.bind(playerHurtSound))
	fragmentCollected.connect(play_sound.bind(collectFragmentSound))
	chargingSpell.connect(play_sound.bind(chargeSpell))
	finishedCharging.connect(play_sound.bind(releaseSpell))

func play_sound(sound: AudioStreamWAV, pitch = 1.0):
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.bus = "Effects"
	audio_stream_player.stream = sound
	audio_stream_player.pitch_scale = pitch
	audio_stream_player.volume_db = _linear_to_db(volume)
	audio_stream_player.connect("finished", _on_audio_player_finished.bind(audio_stream_player))
	add_child(audio_stream_player)
	audio_stream_player.play()
	#fade_volume(0.0, sound.get_length())

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
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), _linear_to_db(volume))

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
