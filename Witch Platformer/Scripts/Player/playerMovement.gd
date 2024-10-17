extends CharacterBody2D

# Change to constants later
const speed = 175
const jump_power = -300
const decel_on_jump_release = 0.25
const accel = 0.05
const friction = 0.05

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATES {IDLE, RUNNING, JUMPING, FALLING, CHARGING, ATTACKING}

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

var current_state = null
var charge_time := 0.0
var max_charge := 3.0
var attacked_charged := false

func _ready():
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power
		#velocity.x += speed * 0.5 * velocity.sign().x
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decel_on_jump_release
	
	var inputDir = Input.get_axis("left", "right")
	if inputDir:
		velocity.x = move_toward(velocity.x, inputDir * speed, speed * accel)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * friction)
	
	state_machine()
	animation_handler()
	move_and_slide()

func state_machine():
	if not is_on_floor():
		if velocity.y > 0:
			current_state = STATES.FALLING
		else:
			current_state = STATES.JUMPING
	else:
		if velocity.x != 0:
			current_state = STATES.RUNNING
		else:
			if Input.is_action_pressed("attack"):
				current_state = STATES.CHARGING
				charge_time += 0.1
				print("Charge Time: " + str(charge_time))
			if Input.is_action_just_released("attack") and charge_time >= max_charge:
				current_state = STATES.ATTACKING
				attacked_charged = true
				charge_time = 0
			if not Input.is_anything_pressed():
				if not attacked_charged:
					current_state = STATES.IDLE

func animation_handler():
	match current_state:
		STATES.IDLE:
			anim.play("idle")
		STATES.RUNNING:
			anim.play("run")
			if velocity.x < 0:
				sprite.flip_h = true
			elif velocity.x > 0:
				sprite.flip_h = false
		STATES.JUMPING:
			anim.play("jump")
		STATES.FALLING:
			anim.play("jump_fall")
		STATES.CHARGING:
			anim.play("charge")
		STATES.ATTACKING:
			anim.play("attack")

func attack():
	attacked_charged = false
 
