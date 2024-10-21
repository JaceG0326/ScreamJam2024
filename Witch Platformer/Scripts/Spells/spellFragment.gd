extends Area2D
class_name SpellFragment

@export var color : Color

@onready var anim = $AnimationPlayer
@onready var light = $Sprite2D/PointLight2D

var triggered = false

func _ready():
	light.color = color
	light.visible = true
	anim.play("idle")

func _physics_process(delta):
	if triggered:
		if anim.is_playing():
			anim.stop()
		var tween = create_tween()
		tween.tween_property(self, "position", Global.platforming_player.position, 1)
		

func _on_area_entered(area):
	triggered = true

func _on_body_entered(body):
	#print("collected")
	queue_free()
