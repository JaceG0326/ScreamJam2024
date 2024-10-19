extends State
class_name EnemyDeath

@export var enemy : CharacterBody2D

func Enter():
	enemy.velocity = Vector2.ZERO
	if enemy is Skeleton:
		enemy.anim.play("death")
	else:
		queue_free()
