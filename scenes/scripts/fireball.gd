extends Area2D
@export var speed: float = 300.0
@export var lifetime: float = 0.5



func _ready() -> void :
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(delta: float) -> void :
	global_position.x += speed * delta * (1 if scale.x > 0 else -1)

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.on_hit_by_fireball()
	elif area.is_in_group("flame"):
		return
	queue_free()
