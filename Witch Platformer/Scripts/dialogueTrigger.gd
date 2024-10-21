extends Area2D

const balloon_scene = preload("res://Scenes/UI/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue: String = ""

var triggered = false

func trigger(body) -> void:
	if not triggered:
		var balloon: Node = balloon_scene.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, dialogue)
		triggered = true
