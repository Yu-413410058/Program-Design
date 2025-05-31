extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_body_entered(body: Node2D) -> void :
    GameManager.add_point()
    print("Coin collected! Current points: ", GameManager.score)
    animation_player.play("pickup")
