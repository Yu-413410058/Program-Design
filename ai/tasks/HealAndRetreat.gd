extends BTAction
class_name HealAndRetreat

@export var retreat_speed: = 50.0
@export var heal_delay: = 2.0
@export var heal_amount: = 5

var boss: Boss
var healing_label: Label
var time_elapsed: = 0.0
var healing_started: = false

func _enter():
	boss = agent as Boss
	if not boss or not boss.player:
		return


	if boss.has_node("HealLabel"):
		healing_label = boss.get_node("HealLabel")
		healing_label.visible = true

	time_elapsed = 0.0
	healing_started = true
	boss.velocity = Vector2.ZERO

func _tick(delta: float) -> Status:
	if not healing_started or not boss or not boss.player:
		return FAILURE

	time_elapsed += delta


	var direction = (boss.global_position - boss.player.global_position).normalized()
	boss.velocity.x = direction.x * retreat_speed
	boss.move_and_slide()


	if time_elapsed >= heal_delay:
		boss.boss_health += heal_amount
		boss.boss_health = min(boss.boss_health, boss.boss_max_health)
		GameManager.boss_health = boss.boss_health
		GameManager.update_boss_health_label()
		return SUCCESS

	return RUNNING

func _exit():
	if healing_label and healing_label.visible:
		healing_label.visible = false
	healing_started = false
	boss.velocity = Vector2.ZERO
