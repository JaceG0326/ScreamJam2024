extends Node

var seen_first_enemy = false
var left_clicked = false

func _input(event):
	if event.is_action_pressed("attack") and !left_clicked:
		left_clicked = true
