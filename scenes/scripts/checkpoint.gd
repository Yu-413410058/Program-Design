extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.spawn_position = body.global_position
		print("Checkpoint reached at: ", body.spawn_position)
