extends BTAction
class_name BossMeteorAttack

@export var wait_time := 2.0

var boss_body: CharacterBody2D
var animation_sprite: AnimatedSprite2D
var spawn_point: Marker2D
var meteor_scene: PackedScene
var player: Node2D    
var attack_started := false
var time_waited := 0.0
var meteor_spawned := false  

func _setup():
	boss_body = agent as CharacterBody2D
	if not boss_body:
		return

	animation_sprite = boss_body.get_node("AnimatedSprite2D")
	spawn_point      = boss_body.get_node("MeteorSpawnPoint")
	meteor_scene     = preload("res://boss/meteor.tscn")
	# lookup the player once here:
	player = boss_body.get_tree().get_first_node_in_group("player") as Node2D

func _enter():
	attack_started = true
	time_waited    = 0.0
	meteor_spawned = false
	animation_sprite.play("meteor")
	boss_body.velocity = Vector2.ZERO

func _tick(delta: float) -> Status:
	if not attack_started:
		return FAILURE

	time_waited += delta

	if not meteor_spawned and time_waited >= wait_time:
		_spawn_meteor()
		meteor_spawned = true
		time_waited = 0.0  # reset timer to delay return

	# let animation continue for another 0.5s after casting
	if meteor_spawned and time_waited >= 0.5:
		return SUCCESS

	return RUNNING

func _spawn_meteor():
	if not meteor_scene or not spawn_point or not player:
		push_error("Missing meteor_scene, spawn_point or player")
		return

	var meteor = meteor_scene.instantiate()
	meteor.global_position = spawn_point.global_position
	# aim toward the player’s position saved at spawn
	meteor.target_position = player.global_position
	# flip sprite if you have a `flip_h` property on meteor
	if meteor.has_node("AnimatedSprite2D"):
		var m_sprite = meteor.get_node("AnimatedSprite2D")
		m_sprite.flip_h = (player.global_position.x < spawn_point.global_position.x)
	
	boss_body.get_parent().add_child(meteor)
	print("🌠 Meteor spawned at ", meteor.global_position, " aiming at ", meteor.target_position)

func _exit():
	attack_started = false
	animation_sprite.play("idle")
