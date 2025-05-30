extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	body.disable_input()
	body.play_death_animation()
	body.velocity.y = -300
	var collision = body.get_node("CollisionShape2D")
	if collision:
		collision.disabled = true  
	timer.start()
	

func _on_timer_timeout() -> void:
	var player = get_tree().get_current_scene().get_node("Player")
	if player:
		player.respawn()
		
