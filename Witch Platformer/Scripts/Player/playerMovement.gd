extends CharacterBody2D

# Change to constants later
@export var speed = 250
@export var jumpPower = -2000
@export var accel = 30
@export var friction = 50
@export var gravity = 120

func _ready():
	pass

func _physics_process(delta):
	var inputDir : Vector2 = input()
	
	if inputDir != Vector2.ZERO:
		accelerate(inputDir)
	else:
		add_friction()
	movement()
	#jump()

func input() -> Vector2:
	var inputDir = Vector2.ZERO
	
	inputDir.x = Input.get_axis("left", "right")
	inputDir = inputDir.normalized()
	return inputDir;

func accelerate(dir):
	velocity = velocity.move_toward(speed * dir, accel)

func add_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)

func movement():
	move_and_slide()

func jump():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jumpPower
	else:
		velocity.y += gravity
