extends CharacterBody2D

var SPEED = 150.0
var JUMP_VELOCITY = -300.0
var dash_speed = 350.0


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow_timer = $shadow_timer
@onready var flame_spawn_point = $Marker2D
@onready var heal_timer = $heal_timer
@export var fireball_cooldown: float = 0.5
@onready var label: Label = $Label


@export var shadow_node : PackedScene
@export var fireball_scene: PackedScene
@export var flame_scene: PackedScene
@export var is_dead = false

var dashing = false
var can_dash = true
var dash_invincible = false
var is_healing = false
var can_move = true
var can_shoot = true
var can_flame = true
var can_heal = true
var flame_instance: Area2D = null
var health = 5
var max_health = 5
var spawn_position: Vector2
var last_direction_input := 1  # Default facing right
var wind_force := 0.0


func _ready() -> void:
	spawn_position = global_position
	GameManager.player = self

func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	GameManager.player_health = GameManager.player_max_health
	GameManager.player_deaths += 1
	$CollisionShape2D.disabled = false
	can_move = true
	can_shoot = true
	can_flame = true
	can_dash = true
	if GameManager.has_method("update_health_label"):
		GameManager.update_health_label()
	else:
		print("⚠️ GameManager doesn't have update_health_label()!")

func _process(_delta):
	# Update max_health based on GameManager's points
	if GameManager.score > max_health - 5:  # Assuming starting health is 5
		max_health = 5 + GameManager.score
		health = max_health 

func handle_flame_ability():
	if Input.is_action_just_pressed("ability_2") and flame_instance == null:
		can_shoot = false
		flame_instance = flame_scene.instantiate()
		flame_instance.scale = Vector2(0.2, 0.2)
		$Marker2D.add_child(flame_instance)	
		flame_instance.position = Vector2.ZERO
		flame_instance.connect("flame_finished", Callable(self, "_on_flame_finished"))
		flame_instance.start_flame()
	
	elif Input.is_action_pressed("ability_2") and flame_instance != null:
		if flame_instance.can_hold:
			flame_instance.hold_flame()

	elif Input.is_action_just_released("ability_2") and flame_instance != null:
		can_shoot = true
		flame_instance.end_flame()

func _on_flame_finished():
	flame_instance = null
	
func heal() -> void:
	if can_heal:
		label.visible = true
		is_healing = true
		can_heal = false
		SPEED /= 2
		JUMP_VELOCITY /= 2
		can_dash = false
		$heal_timer.start()

func shoot_fireball():
	if not can_shoot:
		return
	
	can_shoot = false
	var fireball = fireball_scene.instantiate()
	fireball.global_position = global_position + Vector2(20 * (1 if !$AnimatedSprite2D.flip_h else -1), -10)
	fireball.scale.x = 1 if !$AnimatedSprite2D.flip_h else -1  # Flip fireball based on direction
	get_tree().current_scene.add_child(fireball)

	$fireball_timer.start()  # Start cooldown timer

func _on_fireball_timer_timeout() -> void:
	can_shoot = true

func apply_wind(amount: float) -> void:
	wind_force += amount

func disable_input() -> void:
	can_move = false
	can_shoot = false
	can_flame = false
	can_dash = false

func _physics_process(delta: float) -> void:
	if not can_move:
		velocity += get_gravity() * delta
		velocity.x += wind_force
		move_and_slide()
		return

	# gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x += wind_force
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		velocity.x += wind_force
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_invincible = true
		$dash_timer.start()
		$dash_again_timer.start()
		$shadow_timer.start()
	# Get the input direction and handle the movement/deceleration.
	
	# handle ability 1 - fireball
	if Input.is_action_pressed("ability_1") and can_shoot:
		shoot_fireball()
	
	# handle ability 2 - flame
	handle_flame_ability()
	
	if Input.is_action_just_pressed("ability_3") and can_heal:
		heal()
	
	if flame_instance and is_instance_valid(flame_instance):
		flame_instance.get_node("AnimatedSprite2D").flip_h = $AnimatedSprite2D.flip_h
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		last_direction_input = 1
		animated_sprite_2d.flip_h = false
		$Marker2D.position.x = abs($Marker2D.position.x)
	elif direction < 0:
		last_direction_input = -1
		animated_sprite_2d.flip_h = true
		$Marker2D.position.x = -abs($Marker2D.position.x)
	
	if direction == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("run")
		
	if direction:
		velocity.x = direction * SPEED
		if dashing:
			velocity.x = direction * dash_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if dashing:
			velocity.x = last_direction_input * dash_speed  
	velocity.x += wind_force
	
	move_and_slide()
	wind_force = 0.0

func _on_dash_timer_timeout() -> void:
	dash_invincible = false
	dashing = false
	shadow_timer.stop()

func _on_dash_again_timer_timeout() -> void:
	can_dash = true

func add_shadow():
	var shadow = shadow_node.instantiate()
	shadow.set_property(global_position, $AnimatedSprite2D.scale, animated_sprite_2d.flip_h)
	get_tree().current_scene.add_child(shadow)

func _on_shadow_timer_timeout() -> void:
	if dashing:
		add_shadow()

func play_death_animation() -> void:
	$AnimatedSprite2D.play("death")


func _on_heal_timer_timeout() -> void:
	label.visible = false
	SPEED *=2
	JUMP_VELOCITY *=2
	can_dash = true
	can_heal = true
	is_healing = false
	GameManager.player_health += 3
