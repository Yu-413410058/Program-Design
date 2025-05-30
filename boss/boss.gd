# Boss.gd
extends CharacterBody2D
class_name Boss

@export var wander_speed: float = 50.0
@export var chase_speed: float = 100.0
@export var wander_range: float = 100.0
@export var gravity: float = 980.0
@export var boss_max_health := 100
var boss_health := 100

@onready var detection_area: Area2D = $DetectionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  
@onready var meteor_timer: Timer = $MeteorTimer
@onready var meteor_spawn_point: Marker2D = $MeteorSpawnPoint
@export var meteor_scene: PackedScene

var player: Node2D
var start_position: Vector2
var target_position: Vector2
var player_detected: bool = false
var last_direction: Vector2 = Vector2.ZERO
var battle_started: bool = false

func _ready():
	GameManager.boss_health = boss_health
	GameManager.boss_max_health = boss_max_health
	
	start_position = global_position
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	
	# Assign the health bar directly
	GameManager.boss_health_ui = $BossHealthBar/ProgressBar
	print("✅ Boss health UI assigned!")
	GameManager.update_boss_health_label()
		
func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Update sprite based on movement
	update_sprite_animation()

func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player = body
		player_detected = true
		print("Player detected!")

func _on_detection_area_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_detected = false
		player = null
		print("Player lost!")

func is_player_detected() -> bool:
	return player_detected

func get_random_wander_position() -> Vector2:
	var random_offset = Vector2(
		randf_range(-wander_range, wander_range),
		0
	)
	return start_position + random_offset

func update_sprite_animation():
	if not animated_sprite:
		return
	# Do NOT interrupt special animations
	if animated_sprite.animation == "meteor" or animated_sprite.animation == "melee":
		return
	
	# Check if moving horizontally
	var is_moving = abs(velocity.x) > 5.0  # Small threshold to avoid jitter
	
	if is_moving:
		# Play walking animation
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
		
		# Flip sprite based on direction
		if velocity.x < 0:  # Moving left
			animated_sprite.flip_h = true
		elif velocity.x > 0:  # Moving right
			animated_sprite.flip_h = false
	else:
		# Play idle animation
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

func start_battle():
	print("⚔️ Boss battle started!")
	battle_started = true

# Add these damage methods to handle attacks
func on_hit_by_fireball():
	take_damage(1)  # Fireball does 1 damage
	
func on_hit_by_flame():
	take_damage(2)  # Flame does 2 damage

func take_damage(amount: int):
	boss_health -= amount
	print("Boss took ", amount, " damage Health: ", boss_health, "/", boss_max_health)
	
	# Update the health UI
	GameManager.boss_health = boss_health
	GameManager.update_boss_health_label()
	
	# Check if boss is defeated
	if boss_health <= 0:
		die()

func die():
	queue_free()
	GameManager.show_victory_screen()
