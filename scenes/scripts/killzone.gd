extends Area2D

@onready var timer: Timer = $Timer

var health = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("fireballs"):
		body.queue_free()  # Destroy fireball
		return
	
	if body.dash_invincible:
			return
	body.disable_input()
	body.play_death_animation()
	body.velocity.y = -300
	var collision = body.get_node("CollisionShape2D")
	if collision:
		collision.disabled = true  
	timer.start()
func on_hit_by_fireball():
	if has_node("../"):  # Make sure the parent exists
		var parent = get_parent()
		if parent.has_method("take_damage"):
			parent.take_damage(1)
			
func on_hit_by_flame():
	if has_node("../"):  # Make sure the parent exists
		var parent = get_parent()
		if parent.has_method("take_damage"):
			parent.take_damage(2)

func _on_timer_timeout() -> void:
	var player = get_tree().get_current_scene().get_node("Player")
	if player:
		player.respawn()
