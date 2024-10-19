extends State
class_name EnemyFollow

@export var enemy : CharacterBody2D
@export var move_speed := 30.0
var player : CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Update(delta: float):
	if enemy:
		if enemy.is_hit:
			Transitioned.emit(self, "enemyhurt")

func Physics_Update(delta: float):
	var dir = (player.global_position - enemy.global_position)
	
	if dir.length() < 240:
		if dir.length() < 64:
			Transitioned.emit(self, "enemyattack")
		else:
			enemy.velocity = dir.normalized() * move_speed * Vector2(1, 0)
	else:
		Transitioned.emit(self, "enemyidle")
