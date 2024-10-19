extends CharacterBody2D
class_name Skeleton

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var sword = $SwordHitbox

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var damage := 10.0
@export var knockback_force := 200.0
@export var stun_time := 1.5
@export var attacK_cooldown := 3.0

var is_dead = false
var is_hit = false
var applying_knockback = false
var on_cooldown = false
var attack_timer := 0.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if velocity.length() > 0 and !applying_knockback:
		anim.play("walk")
		
		if velocity.x > 0:
			sprite.flip_h = false
			sword.scale.x = 1
		elif velocity.x < 0:
			sprite.flip_h = true
			sword.scale.x = -1

func attack():
	anim.play("attack")

func die():
	queue_free()

func _on_sword_hitbox_area_entered(area):
	if area is HitboxComponent:
		var player_hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		
		#print("Hit")
		player_hitbox.damage(attack)
