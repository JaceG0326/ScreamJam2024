extends State
class_name EnemyHurt

@export var enemy : CharacterBody2D

func Enter():
	enemy.velocity = Vector2.ZERO
	enemy.anim.play("hurt")

func Physics_Update(delta: float):
	if enemy.is_in_group("Enemies"):
		if !enemy.anim.is_playing():
			if enemy.is_dead:
				Transitioned.emit(self, "enemydeath")
			if enemy.is_hit:
				enemy.is_hit = false
				enemy.applying_knockback = false
				Transitioned.emit(self, "enemyidle")
