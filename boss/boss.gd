
extends CharacterBody2D
class_name Boss

@export var wander_speed: float = 50.0
@export var chase_speed: float = 100.0
@export var wander_range: float = 100.0
@export var gravity: float = 980.0
@export var boss_max_health: = 100
var boss_health: = 100
var current_phase: = 1

@onready var detection_area: Area2D = $DetectionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var meteor_timer: Timer = $MeteorTimer
@onready var meteor_spawn_point: Marker2D = $MeteorSpawnPoint
@export var meteor_scene: PackedScene
@onready var phase2_meteor_timer: Timer = $Phase2MeteorTimer
@onready var fire_ground = get_tree().get_current_scene().get_node("fire_ground")

var player: Node2D
var start_position: Vector2
var target_position: Vector2
var player_detected: bool = false
var last_direction: Vector2 = Vector2.ZERO
var battle_started: bool = false
var damage_types: = {
	"fireball": 1, 
	"flame": 2
}


func _ready():
	GameManager.boss_health = boss_health
	GameManager.boss_max_health = boss_max_health

	start_position = global_position
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)


	GameManager.boss_health_ui = $BossHealthBar / ProgressBar
	print("✅ Boss health UI assigned!")
	GameManager.update_boss_health_label()

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta


	update_sprite_animation()

func _on_detection_area_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player = body
		player_detected = true

func _on_detection_area_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_detected = false
		player = null

func is_player_detected() -> bool:
	return player_detected

func get_random_wander_position() -> Vector2:
	var random_offset = Vector2(
		randf_range( - wander_range, wander_range), 
		0
	)
	return start_position + random_offset

func update_sprite_animation():
	if not animated_sprite:
		return


	if animated_sprite.animation == "meteor":
		return


	var anim_prefix = ""
	if current_phase == 2:
		anim_prefix = "2_"


	var is_moving = abs(velocity.x) > 5.0

	if is_moving:

		var walk_anim = anim_prefix + "walk"
		if animated_sprite.animation != walk_anim:
			animated_sprite.play(walk_anim)


		if velocity.x < 0:
			animated_sprite.flip_h = true
		elif velocity.x > 0:
			animated_sprite.flip_h = false
	else:

		var idle_anim = anim_prefix + "idle"
		if animated_sprite.animation != idle_anim:
			animated_sprite.play(idle_anim)


func start_battle():
	print("⚔️ Boss battle started!")
	battle_started = true

func on_hit_by_fireball():
	take_damage(damage_types.fireball)

func on_hit_by_flame():
	take_damage(damage_types.flame)

func take_damage(amount: int):
	boss_health -= amount
	GameManager.boss_total_damage_taken += amount


	GameManager.boss_health = boss_health
	GameManager.update_boss_health_label()

	if boss_health <= boss_max_health / 2 and current_phase == 1:
		enter_second_phase()


	if boss_health <= 0:
		die()

func die():
	velocity.y = - 200
	$AnimatedSprite2D.play("die")
	GameManager.show_victory_screen()


func enter_second_phase():
	print("Boss in Phase 2")
	current_phase = 2
	phase2_meteor_timer.start()
	fire_ground.visible = true
	fire_ground.set_deferred("monitoring", true)
	fire_ground.set_deferred("monitorable", true)

func _on_phase_2_meteor_timer_timeout() -> void :
	if not player:
		return
	var meteor = meteor_scene.instantiate()
	meteor.global_position = meteor_spawn_point.global_position
	meteor.target_position = player.global_position
	if meteor.has_node("AnimatedSprite2D"):
		var m_sprite = meteor.get_node("AnimatedSprite2D")
		m_sprite.flip_h = (player.global_position.x < meteor_spawn_point.global_position.x)
	get_parent().add_child(meteor)

func heal_self(amount: int):
	boss_health += amount
	boss_health = clamp(boss_health, 0, boss_max_health)
	GameManager.boss_health = boss_health
	GameManager.update_boss_health_label()
