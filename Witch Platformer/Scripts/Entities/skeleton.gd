extends Enemy
class_name Skeleton

@onready var sprite = $Sprite2D
@onready var sword = $SwordHitbox
@onready var hitbox = $HitboxComponent
@onready var shield = $ShieldComponent
@onready var collision = $CollisionShape2D

@export var block_cooldown := 3.0
@export var block_chance := 3

var shield_hit = false
var block_timer := 0.0
var on_block_cooldown = false

func _physics_process(delta):
	if on_block_cooldown and !is_hit:
		if block_timer > block_cooldown:
			block_timer = 0.0
			on_block_cooldown = false
		block_timer += delta
	
	if !is_on_floor() and !is_dead:
		velocity.y += gravity * delta
	
	move_and_slide()
	
	if velocity.length() > 0 and !applying_knockback:
		anim.play("walk")
		
		if velocity.x > 0:
			sprite.flip_h = false
			sword.scale.x = 1
			shield.scale.x = 1
			hitbox.scale.x = 1
			collision.position = Vector2(4, 0)
		elif velocity.x < 0:
			sprite.flip_h = true
			sword.scale.x = -1
			shield.scale.x = -1
			hitbox.scale.x = -1
			collision.position = Vector2(-4, 0)

func attack():
	anim.play("attack")

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
		Stats.score -= 5

func _on_shield_component_area_entered(area):
	shield_hit = true
