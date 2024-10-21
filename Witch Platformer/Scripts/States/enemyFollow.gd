extends State
class_name EnemyFollow

@export var enemy : CharacterBody2D
@export var move_speed := 30.0
var player : Witch

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Update(delta: float):
	if enemy:
		if enemy.is_hit:
			Transitioned.emit(self, "enemyhurt")
			return

func Physics_Update(delta: float):
	var dir = (player.global_position - enemy.global_position)
	
	if dir.length() < 240:
		if dir.length() < 64:
			if enemy is Skeleton:
				if player.attacked_charged and !enemy.on_block_cooldown:
					var block_roll = randi_range(1, 7)
					enemy.on_block_cooldown = true
					if block_roll <= enemy.block_chance:
						Transitioned.emit(self, "enemyblock")
						return
			Transitioned.emit(self, "enemyattack")
			return
		else:
			if enemy is Skeleton:
				if player.attacked_charged and !enemy.on_block_cooldown:
					var block_roll = randi_range(1, 10)
					enemy.on_block_cooldown = true
					if block_roll <= enemy.block_chance:
						Transitioned.emit(self, "enemyblock")
						return
			enemy.velocity.x = (dir.normalized() * move_speed * Vector2(1, 0)).x
	else:
		Transitioned.emit(self, "enemyidle")
		return
