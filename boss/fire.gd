extends Area2D

@export var damage_amount: = 1
@export var damage_interval: = 2.0

var player_in_fire: = false

@onready var damage_timer: Timer = $Timer

func _ready() -> void :
    damage_timer.wait_time = damage_interval
    damage_timer.one_shot = false
    damage_timer.autostart = false

func _on_body_entered(body):
    if body.name == "Player":
        print("player entered fire")
        player_in_fire = true
        damage_timer.start()

func _on_body_exited(body):
    if body.name == "Player":
        player_in_fire = false
        damage_timer.stop()

func _on_timer_timeout() -> void :
    if player_in_fire:
        print("take damage from fire")
        GameManager.take_damage(damage_amount)
