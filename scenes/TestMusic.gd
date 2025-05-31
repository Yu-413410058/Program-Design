extends Area2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	pass
func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		Bgm.stop()  # Stops global BGM
		if audio_player:
			audio_player.play()
func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		if audio_player and audio_player.playing:
			audio_player.stop()  # Stop the test sound
		Bgm.play()  # Resume the global BGM
