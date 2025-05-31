extends Area2D

@export var wind_strength: = 1500.0
var player = null

func _physics_process(delta):
    if player and player.has_method("apply_wind"):
        player.apply_wind(wind_strength * delta)

func _on_body_entered(body):
    if body.name == "Player":
        player = body

func _on_body_exited(body):
    if body == player:
        player = null
