extends Node

var score := 0
var player_health := 5
var player_max_health := 5
var boss_health := 100
var boss_max_health := 100
var player_deaths := 0
var play_time := 0.0

@onready var respawn_timer : Timer = $Timer

var health_ui = null
var boss_health_ui = null
var player: Node = null
var boss_node: Node = null
@onready var victory_screen := get_tree().get_root().get_node("res://boss/VictoryScreen.tscn")

func _ready() -> void:
	await get_tree().process_frame
	var ui_path = "/root/Game/UI/health_ui"
	if has_node(ui_path):
		health_ui = get_node(ui_path)
		update_health_label()
	else:
		print("⚠️ Could not find HealthUI at path: ", ui_path)

func monitor_health() -> void:
	if player_health >= player_max_health:
		player_health = player_max_health
	if player_health <= 0 and player and $Timer.is_stopped():
		player.disable_input()
		player.play_death_animation()
		player.velocity.y = -300
		player.get_node("CollisionShape2D").disabled = true
		$Timer.start()

func take_damage(amount: int) -> void:
	player_health -= amount
	update_health_label()

func add_point() -> void:
	score += 1
	player_max_health += 1
	update_health_label()

func update_health_label() -> void:
	if health_ui:
		health_ui.update_health(player_health, player_max_health)
	else:
		print("⚠️ health_ui is null!")

func _process(_delta) -> void:
	monitor_health()
	update_health_label()
	play_time += _delta

func _on_timer_timeout() -> void:
	player_health = player_max_health
	update_health_label()
	player.respawn()


# below is boss part
func update_boss_health_label() -> void:
	if GameManager.boss_health_ui:
		# Set the values directly on the ProgressBar
		GameManager.boss_health_ui.max_value = boss_max_health
		GameManager.boss_health_ui.value = boss_health
	else:
		print("⚠️ boss_health_ui is null! (boss health)")

func show_victory_screen():
	if not victory_screen:
		push_error("Victory screen not found")
		return

	victory_screen.visible = true

	var deaths = player_deaths
	var total_seconds = int(play_time)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60

	victory_screen.get_node("Panel/DeathLabel").text = "Deaths: %d" % deaths
	victory_screen.get_node("Panel/TimeLabel").text = "Time: %02d:%02d" % [minutes, seconds]
