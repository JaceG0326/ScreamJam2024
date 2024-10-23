extends CharacterBody2D
class_name Enemy

var anim : AnimationPlayer = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var damage := 10.0
@export var knockback_force := 200.0
@export var stun_time := 1.5
@export var attack_range := 64
@export var attack_cooldown := 3.0

var is_dead = false
var is_hit = false
var applying_knockback = false
var on_cooldown = false
var attack_timer := 0.0

func _ready():
	anim = get_node_or_null("AnimationPlayer")

func _physics_process(delta):
	if !is_on_floor() and !is_dead:
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if velocity.length() > 0 and !applying_knockback:
		anim.play("walk")

func attack():
	anim.play("attack")

func die():
	Stats.score += 20
	queue_free()
