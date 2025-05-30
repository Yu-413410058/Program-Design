extends Area2D
@export var speed: float = 300.0
@export var lifetime: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += speed * delta * (1 if scale.x > 0 else -1)

func _on_area_entered(area):
	if area.is_in_group("enemies"):  # Damage enemy
		area.on_hit_by_fireball()
	elif area.is_in_group("flame"):  # Damage enemy
		return
	queue_free()
