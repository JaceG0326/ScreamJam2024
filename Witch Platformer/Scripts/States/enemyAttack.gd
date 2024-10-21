extends State
class_name EnemyAttack

@export var enemy : CharacterBody2D
@export var cooldown := 2.0

var on_cooldown = false
var cooldown_timer := 0.0
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
	
	if dir.length() < 64:
		enemy.velocity.x = 0
		if enemy is Skeleton:
			if !on_cooldown:
				enemy.attack()
				on_cooldown = true
			else:
				if !enemy.anim.is_playing():
					enemy.anim.play("idle")
				if cooldown_timer < cooldown:
					cooldown_timer += delta
				else:
					on_cooldown = false
					cooldown_timer = 0.0
	else:
		on_cooldown = false
		cooldown_timer = 0.0
		Transitioned.emit(self, "enemyfollow")
