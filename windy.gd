extends Area2D

@export var push_force := 100.0

func _on_body_entered(body):
	if body.has_method("apply_wind_force"):
		body.apply_wind_force(push_force)

func _on_body_exited(body):
	if body.has_method("stop_wind_force"):
		body.stop_wind_force()
