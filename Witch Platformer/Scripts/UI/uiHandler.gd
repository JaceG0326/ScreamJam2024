extends CanvasLayer

@onready var level_info = $HUD/MarginContainer
@onready var level_complete_label = $HUD/MarginContainer/VBoxContainer/LevelComplete
@onready var level_info_panel = $HUD/MarginContainer/VBoxContainer/PanelContainer

func _ready():
	level_complete_label.visible = false
	level_info.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	level_info_panel.set_h_size_flags(Container.SIZE_SHRINK_BEGIN)

func _process(delta):
	if Global.level_finished and !level_complete_label.visible:
		level_complete_label.visible = true
		level_info.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		level_info_panel.set_h_size_flags(Container.SIZE_SHRINK_CENTER)

