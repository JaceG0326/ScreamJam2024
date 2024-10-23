extends Node

# Singleton which stores references to other Nodes
var player_camera : Camera2D = null
var platforming_player : Witch = null

@onready var levels : Array[PackedScene] = [preload("res://Scenes/Menus/title_screen.tscn"), preload("res://Scenes/Levels/testLevel.tscn"), preload("res://Scenes/Levels/level1.tscn")]

var level_start = false
var level_finished = false
var move_to_next_level = false
var current_level
var current_level_id = 0
var restarting = false

@export var room_pause: bool = false
@export var room_pause_time: float = 0.2

enum { UP, RIGHT, DOWN, LEFT, }

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().create_timer(0.1).timeout
	#$SceneTransition/AnimationPlayer.play("RESET")

func change_room(room_position: Vector2, room_size: Vector2) -> void:
	player_camera.current_room_center = room_position
	player_camera.current_room_size = room_size
	#$SceneTransition/AnimationPlayer.play("fade out")
	#await get_tree().create_timer(room_pause_time)
	#if $SceneTransition/AnimationPlayer.assigned_animation == "fade out":
	#	$SceneTransition/AnimationPlayer.play("fade in")

#func _unhandled_key_input(event):
	#if event is InputEventKey:
		#if event.keycode == KEY_BRACKETLEFT:
			#get_tree().paused = true
		#if event.keycode == KEY_BRACKETRIGHT:
			#get_tree().paused = false

func reload_level():
	restarting = true
	platforming_player.is_dead = true
