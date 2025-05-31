# Meteor.gd
extends Area2D 

@export var fall_speed := 400.0
@export var lifetime := 1.0
var target_position: Vector2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	# Compute direction once, based on the saved target_position
	if target_position:
		var dir = (target_position - global_position).normalized()
		# Flip sprite based on horizontal sign
		sprite.flip_h = dir.x > 0
		set_physics_process(true)
	# Start the timer to auto-remove
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.start()
	
func _physics_process(delta: float) -> void:
	if target_position:
		position += (target_position - global_position).normalized() * fall_speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.dash_invincible:
			return
		print("💥 Player smashed by meteor!")
		GameManager.take_damage(2)
		queue_free()
	elif body is TileMap:
		print("🌋 Meteor hit the ground")
		queue_free()
	elif body.is_in_group("enemies"):
		return
		


func _on_timer_timeout() -> void:
	queue_free()
