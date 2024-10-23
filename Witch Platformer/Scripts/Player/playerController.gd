extends CharacterBody2D
class_name Witch

# Change to constants later
const speed = 175
const jump_power = -300
const decel_on_jump_release = 0.25
const accel = 0.05
const friction = 0.05

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATES { IDLE, RUNNING, JUMPING, FALLING, CHARGING, ATTACKING, HURT, DEAD }

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var spell_projectile = preload("res://Objects/Spells/spell_projectile.tscn")

var current_state = null
var charge_time := 0.0
var max_charge := 3.0
var attacked_charged := false
var is_dead := false
var is_hit := false
var applying_knockback := false
var goal = null
var tween_pos : Tween = null

# Room swapping
enum Touching_Side { BOTH, HORIZONTAL, VERTICAL, NONE }

func _ready():
	set_collision_mask_value(8, true)
	
	Global.platforming_player = self
	Global.level_start = true
	if Global.restarting:
		Stats.score = 0
		Global.restarting = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !Global.level_finished:
		set_collision_mask_value(8, true)
		
		if Input.is_action_pressed("down"):
			set_collision_mask_value(8, false)
		
		if current_state != STATES.DEAD and current_state != STATES.HURT:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = jump_power
				if Input.is_action_pressed("down"):
					set_collision_mask_value(8, false)
				#velocity.x += speed * 0.5 * velocity.sign().x
			
			if Input.is_action_just_released("jump") and velocity.y < 0:
				velocity.y *= decel_on_jump_release
			
			var inputDir = Input.get_axis("left", "right")
			if inputDir:
				velocity.x = move_toward(velocity.x, inputDir * speed, speed * accel)
			else:
				velocity.x = move_toward(velocity.x, 0, speed * friction)
		elif velocity:
			velocity.x = move_toward(velocity.x, 0, speed * friction)
	elif velocity and tween_pos == null:
		tween_pos = get_tree().create_tween()
		tween_pos.tween_property(self, "position:x", goal.get_child(0).position.x, 1)
	elif !tween_pos.is_running():
		velocity = Vector2.ZERO
	
	state_machine()
	animation_handler()
	move_and_slide()

func state_machine():
	if Global.level_finished:
		current_state = STATES.IDLE
		return
	if is_hit or applying_knockback:
		current_state = STATES.HURT
		attacked_charged = false
		charge_time = 0.0
		return
	if is_dead:
		current_state = STATES.DEAD
		return
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
				if charge_time == 0.0: SfxAudio.chargingSpell.emit()
				current_state = STATES.CHARGING
				charge_time += 0.1
				if charge_time >= max_charge:
					attacked_charged = true
					#print("CHARGED")
				else:
					#print("Charge Time: " + str(charge_time))
					attacked_charged = false
			if Input.is_action_just_released("attack"):
				if charge_time >= max_charge or attacked_charged:
					current_state = STATES.ATTACKING
					charge_time = 0
					SfxAudio.finishedCharging.emit()
				else:
					attacked_charged = false
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
				if !applying_knockback: sprite.flip_h = true
			elif velocity.x > 0:
				if !applying_knockback: sprite.flip_h = false
		STATES.JUMPING:
			anim.play("jump")
		STATES.FALLING:
			anim.play("jump_fall")
		STATES.CHARGING:
			anim.play("charge")
		STATES.ATTACKING:
			anim.play("attack")
		STATES.HURT:
			pass
		STATES.DEAD:
			anim.play("death")

func attack():
	attacked_charged = false

func on_hit():
	applying_knockback = false
	is_hit = false

func on_death():
	print("Dead")
	if !Global.restarting:
		Stats.score -= 50
	get_tree().reload_current_scene()

func spawn_projectile():
	var spell = spell_projectile.instantiate()
	if not sprite.flip_h: spell.global_position = global_position + Vector2(20, 8.5)
	else: spell.global_position = global_position + Vector2(-16, 2.5)
	get_parent().add_child(spell)
 
func _on_room_detector_area_entered(area):
	if not Global.player_camera or not is_instance_valid(Global.player_camera):
		return
	# Gets collision shape and size of room
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
	var size: Vector2 = collision_shape.shape.size * 2
	
	# Gives the player extra upward velocity if it is entering a room above it
	if Global.player_camera.current_room_size != Vector2.ZERO:
		var side = check_room_edge(Global.player_camera.current_room_center, Global.player_camera.current_room_size, collision_shape.global_position, size)
	
		if side == Global.UP:
			velocity.y = jump_power
	
	# Changes camera's current room and size. check PlayerCamera script for more info
	Global.change_room(collision_shape.global_position, size)

# Checks which edge of a touching b. If a and b are overlapping or not touching 
# the function will push_error(). a is the previous room and b is the room being entered
func check_room_edge(a_center: Vector2, a_size: Vector2, b_center: Vector2, b_size: Vector2) -> int:
	
	var relative_center: Vector2 = a_center - b_center
	
	var total_size: Vector2 = a_size + b_size
	
	var horizontal_overlap: int = total_size.x / 2 - abs(relative_center.x)
	var vertical_overlap: int = total_size.y / 2 - abs(relative_center.y)
	
	var touching: int
	
	if horizontal_overlap > 0 and vertical_overlap > 0:
		touching = Touching_Side.BOTH
	elif horizontal_overlap > 0 and vertical_overlap == 0:
		touching = Touching_Side.VERTICAL
	elif horizontal_overlap == 0 and vertical_overlap > 0:
		touching = Touching_Side.HORIZONTAL	
	elif horizontal_overlap <= 0 and vertical_overlap <= 0:
		touching = Touching_Side.NONE
	else:
		push_error("error calculating room edge")
		
	match touching:
		Touching_Side.BOTH:
			#push_error("rooms overlapping")
			pass
		Touching_Side.NONE:
			push_error("player crossed two rooms that are not touching")
		Touching_Side.VERTICAL:
			if a_center.y < b_center.y: # up is negative y
				return Global.DOWN
			elif a_center.y > b_center.y:
				return Global.UP
			else:
				push_error("rooms touching vertically, but at same y coordinate")
		Touching_Side.HORIZONTAL:
			if a_center.x < b_center.x:
				return Global.RIGHT
			elif a_center.x > b_center.x:
				return Global.LEFT
			else:
				push_error("rooms touching horizontally, but at same x coordinate")
				
	# Fail safe
	return Global.RIGHT

func _on_goal_detector_area_entered(area):
	goal = area
	Global.level_finished = true
