extends State
class_name EnemyAttack

@export var enemy : Enemy
\
var player : CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Update(delta: float):
	if enemy:
		if enemy.is_hit:
			enemy.velocity.x = 0
			Transitioned.emit(self, "enemyhurt")

func Physics_Update(delta: float):
	var dir = (player.global_position - enemy.global_position)
	
	if player.is_dead:
		Transitioned.emit(self, "enemyidle")
		return
	
	if dir.length() < enemy.attack_range:
		enemy.velocity.x = 0
		if enemy is Enemy:
			if !enemy.on_cooldown:
				enemy.attack()
				enemy.on_cooldown = true
			else:
				if !enemy.anim.current_animation != "idle":
					await enemy.anim.animation_finished
					enemy.anim.play("idle")
					return
				if enemy.attack_timer < enemy.attack_cooldown:
					enemy.attack_timer += delta
					return
				else:
					enemy.on_cooldown = false
					enemy.attack_timer = 0.0
					return
	else:
		enemy.on_cooldown = false
		enemy.attack_timer = 0.0
		Transitioned.emit(self, "enemyfollow")
		return
