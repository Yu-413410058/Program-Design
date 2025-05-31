extends BTAction
class_name Boss2_MeleeAttack

@export var jump_force: float = 500.0
@export var float_duration: float = 0.3
@export var ground_wait_duration: float = 0.5
@export var fall_speed: float = 500.0
@export var horizontal_speed: float = 600.0

var boss_body: CharacterBody2D
var animation_sprite: AnimatedSprite2D
var melee_attack_area: Area2D
var melee_collision: CollisionShape2D
var player: Node2D
var target_x_position: float
var is_attacking: bool = false
var attack_phase: String = ""
var float_timer: float = 0.0
var ground_timer: float = 0.0

func _setup():
	# Get references to boss components
	boss_body = agent as CharacterBody2D
	
	animation_sprite = boss_body.get_node("AnimatedSprite2D")  
		
	melee_attack_area = boss_body.get_node("MeleeAttack") 
	
		
	melee_collision = melee_attack_area.get_node("CollisionShape2D")
	
	# Find player by group
	player = boss_body.get_tree().get_first_node_in_group("player")
	

func _enter():
	is_attacking = true
	attack_phase = "jumping"
	float_timer = 0.0
	ground_timer = 0.0

	# Start jump
	boss_body.velocity.y = -jump_force
	
	# Store player's current position for targeting
	target_x_position = player.global_position.x
	
	# Disable melee collision initially
	melee_collision.disabled = true

func _tick(delta: float) -> Status:
	
	boss_body.move_and_slide()
	
	match attack_phase:
		"jumping":
			return _handle_jumping_phase(delta)
		"floating":
			return _handle_floating_phase(delta)
		"falling":
			return _handle_falling_phase(delta)
		"ground_wait":
			return _handle_ground_wait_phase(delta)
	
	return FAILURE

func _handle_jumping_phase(delta: float) -> Status:
	float_timer += delta
	boss_body.velocity.y = -jump_force
	boss_body.velocity.x = 0

	if float_timer >= float_duration:
		attack_phase = "falling"
		animation_sprite.play("2_lie")
		float_timer = 0.0
	return RUNNING


func _handle_floating_phase(delta: float) -> Status:
	float_timer += delta
	
	# Keep boss floating in place
	boss_body.velocity.y = 0
	
	# Move horizontally towards target position
	var distance_to_target = target_x_position - boss_body.global_position.x
	if abs(distance_to_target) > 5:  # Small threshold to avoid jittering
		boss_body.velocity.x = sign(distance_to_target) * horizontal_speed
	else:
		boss_body.velocity.x = 0
	
	if float_timer >= float_duration:
		attack_phase = "falling"
		# Switch to lie animation and enable attack collision
		animation_sprite.play("2_lie")
		
		# Start falling with increased speed towards target
		boss_body.velocity.y = fall_speed
	
	return RUNNING

func _handle_falling_phase(delta: float) -> Status:
	var dx = target_x_position - boss_body.global_position.x
	boss_body.velocity.x = sign(dx) * horizontal_speed if abs(dx) > 5 else 0
	boss_body.velocity.y = fall_speed

	if boss_body.is_on_floor():
		attack_phase = "ground_wait"
		ground_timer = 0.0
		boss_body.velocity = Vector2.ZERO
	return RUNNING


func _handle_ground_wait_phase(delta: float) -> Status:
	ground_timer += delta
	animation_sprite.play("2_lie")
	animation_sprite.position.y += 1.5
	melee_collision.disabled = false
	if ground_timer >= ground_wait_duration:
		# Attack complete, clean up
		_exit()
		return SUCCESS
	
	return RUNNING

func _exit():
	is_attacking = false
	
	# Disable melee attack collision
	melee_collision.disabled = true
	
	# Return to idle animation
	animation_sprite.play("2_idle")
	animation_sprite.position.y = 0

	
	# Reset any velocity modifications
	boss_body.velocity.x = 0
	
