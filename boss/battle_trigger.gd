extends Area2D

var player_inside: = false
@onready var battlemusic: AudioStreamPlayer = $AudioStreamPlayer


func _on_body_entered(body):
	if not battlemusic.playing:
		battlemusic.play()
	if body.is_in_group("player"):
		player_inside = true
		print("Player entered battle area")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		print("Player exited battle area")
