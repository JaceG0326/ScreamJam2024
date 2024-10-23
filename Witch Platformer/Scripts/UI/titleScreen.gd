extends Node2D

@onready var ghost_player = $CharacterBody2D
@onready var music_slider = $UI/OptionsScreen/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/MusicVolume/MusicVolumeSlider
@onready var effects_slider = $UI/OptionsScreen/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/EffectsVolume/EffectsVolumeSlider
@onready var start_screen = $UI/StartScreen
@onready var options_screen = $UI/OptionsScreen

@export_range(100, 200) var parallax_move_speed := 150

func _ready():
	start_screen.show()
	options_screen.hide()
	ghost_player.velocity = Vector2(parallax_move_speed, 0)
	music_slider.value = MusicAudio.volume
	effects_slider.value = SfxAudio.volume
	MusicAudio.levelStart.emit()

func _physics_process(delta):
	ghost_player.move_and_slide()

func _on_start_pressed():
	Global.move_to_next_level = true

func _on_options_pressed():
	start_screen.hide()
	options_screen.show()

func _on_music_volume_slider_value_changed(value):
	MusicAudio.volume = value
	print(MusicAudio.volume)

func _on_effects_volume_slider_value_changed(value):
	SfxAudio.volume = value
	print(SfxAudio.volume)

func _on_back_pressed():
	start_screen.show()
	options_screen.hide()
