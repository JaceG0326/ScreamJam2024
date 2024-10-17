extends CharacterBody2D

# Change to constants later
const speed = 175
const jumpPower = -300
const decel_on_jump_release = 0.25
const accel = 0.05
const friction = 0.05

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpPower
		#velocity.x += speed * 0.5 * velocity.sign().x
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decel_on_jump_release
	
	var inputDir = Input.get_axis("left", "right")
	if inputDir:
		velocity.x = move_toward(velocity.x, inputDir * speed, speed * accel)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * friction)
	
	animation_handler()
	move_and_slide()

func animation_handler():
		if velocity == Vector2.ZERO:
			anim.play("idle")
		elif is_on_floor():
			if velocity.x > 0:
				anim.play("run")
				sprite.flip_h = false
				sprite.offset.x = 24
			elif velocity.x < 0:
				anim.play("run")
				sprite.flip_h = true
				sprite.offset.x = -24
		else:
			#play jumping/falling animations
			pass
