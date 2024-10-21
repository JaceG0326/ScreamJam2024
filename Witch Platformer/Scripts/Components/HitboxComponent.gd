extends Area2D
class_name HitboxComponent

@export var health_component : HealthComponent

func damage(attack: Attack):
	#print("hit")
	if health_component:
		health_component.damage(attack)
