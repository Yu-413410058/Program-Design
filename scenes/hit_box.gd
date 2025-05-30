extends Area2D
@onready var damage_timer: Timer = $Timer
var can_take_damage = true

func _ready():
	var boss = get_parent()
	if not damage_timer:
		damage_timer = Timer.new()
		add_child(damage_timer)
		damage_timer.wait_time = 0.5  # Same as flame damage interval
		damage_timer.one_shot = true
		damage_timer.connect("timeout", Callable(self, "_on_damage_timer_timeout"))

func on_hit_by_fireball():
	var boss = get_parent()
	if boss and boss.has_method("take_damage"):
		boss.take_damage(1)
		
func on_hit_by_flame():
	if not can_take_damage:
		return
		
	var boss = get_parent()
	if boss and boss.has_method("take_damage"):
		boss.take_damage(2)
		can_take_damage = false
		damage_timer.start()

func _on_timer_timeout() -> void:
	can_take_damage = true
