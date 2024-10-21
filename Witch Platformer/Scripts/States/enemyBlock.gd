extends State
class_name EnemyBlock

@export var enemy : CharacterBody2D
var player : Witch

func Enter():
	enemy.velocity.x = 0
	if enemy is Skeleton:
		enemy.anim.play("block")
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	if enemy.is_in_group("Enemies"):
		if enemy.is_hit:
			enemy.velocity.x = 0
			Transitioned.emit(self, "enemyhurt")
			return
		if !enemy.anim.is_playing():
			if enemy is Skeleton:
				if player.attacked_charged:
					return
				elif enemy.shield_hit:
					enemy.shield_hit = false
					Transitioned.emit(self, "enemyfollow")
					return
				else:
					await get_tree().create_timer(2.0).timeout
					Transitioned.emit(self, "enemyfollow")
					return
