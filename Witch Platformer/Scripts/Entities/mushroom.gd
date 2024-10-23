extends Enemy
class_name Mushroom

@onready var sprite = $Sprite2D
@onready var attack1Hitbox = $Attack1Hitbox
@onready var attack2Hitbox = $Attack2Hitbox
@onready var hitbox = $HitboxComponent
@onready var collision = $CollisionShape2D

var alt_attack = false

func _physics_process(delta):
	if !is_on_floor() and !is_dead:
		velocity.y += gravity * delta
	
	if on_cooldown:
		if anim.current_animation != "idle":
			await anim.animation_finished
			anim.play("idle")
		if attack_timer < attack_cooldown:
			attack_timer += delta
		else:
			attack_timer = 0
			on_cooldown = false
	
	move_and_slide()
	
	if velocity.length() > 0 and !applying_knockback:
		anim.play("walk")
		
		if velocity.x > 0:
			sprite.flip_h = false
			attack1Hitbox.scale.x = 1
			hitbox.scale.x = 1
			collision.position = Vector2(4, 6)
		elif velocity.x < 0:
			sprite.flip_h = true
			attack1Hitbox.scale.x = -1
			hitbox.scale.x = -1
			collision.position = Vector2(-4, 6)

func attack():
	randomize()
	var roll = randi_range(0, 6)
	if roll <= 2:
		alt_attack = true
		anim.play("attack2")
	else:
		anim.play("attack1")

func die():
	Stats.score += 30
	queue_free()

func _on_attack_hitbox_area_entered(area):
	if area is HitboxComponent:
		var player_hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		
		#print("Hit")
		if !alt_attack:
			player_hitbox.damage(attack)
		else:
			attack.attack_damage = damage * 3
			attack.knockback_force = knockback_force * 1.5
			player_hitbox.damage(attack)
		Stats.score -= 5
