extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
var health : float

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	print(health)
	
	var entity = get_parent()
	if entity is Skeleton:
		if health <= 0:
			entity.is_dead = true
		entity.is_hit = true
		entity.velocity = Vector2.ZERO
		apply_knockback(entity, attack)
	elif entity is Witch:
		if health <= 0:
			entity.is_dead = true
		entity.is_hit = true
		entity.velocity = Vector2.ZERO
		apply_knockback(entity, attack)

func apply_knockback(entity: CharacterBody2D, attack: Attack):
	if entity is Witch:
		entity.anim.play("hurt")
		SfxAudio.playerHurt.emit()
	entity.velocity = (entity.global_position - attack.attack_position).normalized() * attack.knockback_force
	entity.applying_knockback = true
