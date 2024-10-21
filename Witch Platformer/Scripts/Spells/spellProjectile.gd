extends RigidBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer

@export var speed := 200.0

var target = null
var dir = Vector2.ZERO

@export var damage := 20.0
@export var knockback_force := 200.0
@export var stun_time := 1.5

func _ready():
	anim.play("fire")
	dir = get_global_mouse_position() - global_position
	look_at(get_global_mouse_position())

func _physics_process(delta):
	if target != null:
		pass
	else:
		set_constant_force(speed * dir.normalized())

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fire":
		anim.play("fly")

func destroy():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemies"):
		return
	destroy()

func _on_area_2d_area_entered(area):
	#print(area.name)
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		
		hitbox.damage(attack)
	destroy()
