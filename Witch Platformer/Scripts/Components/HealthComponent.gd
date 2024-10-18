extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
var health : float

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		var enemy = get_parent()
		
		if enemy is Skeleton:
			enemy.anim.play("death")
		else:
			enemy.queue_free()
