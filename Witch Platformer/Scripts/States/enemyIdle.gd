extends State
class_name EnemyIdle

var move_direction : Vector2
var wander_time : float

@export var enemy : CharacterBody2D
@export var move_speed := 10.0
@export var right_ground_sensor : RayCast2D
@export var right_wall_sensor : RayCast2D
@export var left_ground_sensor : RayCast2D
@export var left_wall_sensor : RayCast2D

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 4)

func Enter():
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
		handle_sensors()

func handle_sensors():
	if not right_ground_sensor.is_colliding():
		move_direction = Vector2(-1, 0)
		#print("No floor found on right")
		wander_time = randf_range(3, 6)
	elif not left_ground_sensor.is_colliding():
		move_direction = Vector2(1, 0)
		#print("No floor found on left")
		wander_time = randf_range(3, 6)
	if right_wall_sensor.is_colliding():
		move_direction = Vector2(-1, 0)
		#print("Wall found on right")
		wander_time = randf_range(3, 6)
	elif left_wall_sensor.is_colliding():
		move_direction = Vector2(1, 0)
		#print("Wall found on left")
		wander_time = randf_range(3, 6)