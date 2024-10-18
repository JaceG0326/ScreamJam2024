extends CharacterBody2D
class_name Skeleton

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if velocity.length() > 0 and anim.current_animation != "death":
		anim.play("walk")
		
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true

func die():
	queue_free()
