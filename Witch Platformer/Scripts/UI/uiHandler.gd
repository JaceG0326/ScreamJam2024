extends CanvasLayer

@onready var hud = $HUD
@onready var pause_menu = $PauseMenu
@onready var options_menu = $OptionsScreen
@onready var level_info = $HUD/MarginContainer
@onready var level_complete_label = $HUD/MarginContainer/VBoxContainer/LevelComplete
@onready var level_info_panel = $HUD/MarginContainer/VBoxContainer/PanelContainer
@onready var level_clock = $HUD/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/Time/Clock
@onready var music_slider = $OptionsScreen/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/MusicVolume/MusicVolumeSlider
@onready var effects_slider = $OptionsScreen/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/EffectsVolume/EffectsVolumeSlider

var started = false

func _ready():
	if Global.level_start:
		hud.show()
		pause_menu.hide()
		options_menu.hide()
		level_complete_label.visible = false
	else:
		hud.hide()
		pause_menu.hide()
		options_menu.hide()
		level_complete_label.hide()
	level_info.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	level_info_panel.set_h_size_flags(Container.SIZE_SHRINK_BEGIN)
	music_slider.value = MusicAudio.volume
	effects_slider.value = SfxAudio.volume

func _process(delta):
	if Global.level_start:
		if !started:
			started = true
			hud.show()
			pause_menu.hide()
			options_menu.hide()
			level_complete_label.hide()
		
		if Global.level_finished and !level_complete_label.visible:
			level_complete_label.show()
			level_info.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
			level_info_panel.set_h_size_flags(Container.SIZE_SHRINK_CENTER)

func handle_pause():
	get_tree().paused = !get_tree().paused
	hud.visible = !hud.visible
	pause_menu.visible = !pause_menu.visible

func _input(event):
	if event.is_action_released("pause") and Global.level_start:
		if options_menu.visible:
			options_menu.hide()
			pause_menu.show()
		else:
			handle_pause()

func _on_back_pressed():
	handle_pause()

func _on_retry_pressed():
	handle_pause()
	Global.reload_level()

func _on_options_pressed():
	pause_menu.hide()
	options_menu.show()

func _on_options_back_pressed():
	pause_menu.show()
	options_menu.hide()

func _on_music_volume_slider_value_changed(value):
	MusicAudio.volume = value

func _on_effects_volume_slider_value_changed(value):
	SfxAudio.volume = value
