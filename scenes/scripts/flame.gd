extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var damage_timer: Timer = $DamageTimer
signal flame_finished

var enemies_in_area: Array = []
var is_ending = false
var can_hold = false
var last_animation = ""

func _ready():
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	damage_timer.start()

func start_flame():
	can_hold = false
	last_animation = "start"
	animated_sprite.play(last_animation)

func hold_flame():
	if animated_sprite.animation != "loop":
		last_animation = "loop"
		animated_sprite.play(last_animation)

func end_flame():
	can_hold = false
	last_animation = "end"
	animated_sprite.play(last_animation)

func _on_animation_finished():
	if last_animation == "start":
		can_hold = true
	elif last_animation == "end":
		emit_signal("flame_finished")
		damage_timer.stop()
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("bird"):
		if area.has_method("on_hit_by_flame"):
			area.on_hit_by_fireball()
	if area.is_in_group("enemies") and not enemies_in_area.has(area):
		enemies_in_area.append(area)

func _on_area_exited(area):
	if area.is_in_group("enemies") and enemies_in_area.has(area):
		enemies_in_area.erase(area)

func _on_damage_timer_timeout():
	for enemy in enemies_in_area:
		if enemy.has_method("on_hit_by_flame"):
			enemy.on_hit_by_flame()
