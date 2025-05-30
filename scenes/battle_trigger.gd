extends Area2D
@onready var boss: Boss = $"../boss"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("🔔 Battle triggered!")
		boss.start_battle()
		
		# Optional: disable the trigger after it's activated once
		monitoring = false
