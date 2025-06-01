extends Node

var score: = 0
var player_health: = 5
var player_max_health: = 5
var boss_health: = 100
var boss_max_health: = 100
var boss_total_damage_taken: = 0
var player_total_damage_taken: = 0
var player_deaths: = 0
var play_time: = 0.0

@onready var respawn_timer: Timer = $Timer


var victory_screen = null
var health_ui = null
var boss_health_ui = null
var player: Node = null
var boss_node: Node = null

func _ready() -> void :
	await get_tree().process_frame
	find_ui_elements()

func find_ui_elements():
	var game_node = get_tree().get_first_node_in_group("main")
	if not game_node:
		game_node = get_node_or_null("/root/Game")

	if game_node:
		health_ui = game_node.get_node_or_null("UI/health_ui")
		victory_screen = game_node.get_node_or_null("UI/VictoryScreen")
		boss_health_ui = game_node.get_node_or_null("boss/BossHealthBar/ProgressBar")

	if not health_ui:
		health_ui = get_tree().get_first_node_in_group("health_ui")
	if not victory_screen:
		victory_screen = get_tree().get_first_node_in_group("victory_screen")
	if not boss_health_ui:
		boss_health_ui = get_tree().get_first_node_in_group("boss_health_ui")

	if not boss_health_ui and game_node:
		var boss_health_bar = find_node_recursive(game_node, "BossHealthBar")
		if boss_health_bar:
			boss_health_ui = boss_health_bar.get_node_or_null("ProgressBar")

	if health_ui:
		update_health_label()

func find_node_recursive(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	for child in node.get_children():
		var result = find_node_recursive(child, target_name)
		if result:
			return result
	return null

func monitor_health() -> void :
	if player_health >= player_max_health:
		player_health = player_max_health
	if player_health <= 0 and player and $Timer.is_stopped():
		player.disable_input()
		player.play_death_animation()
		player.velocity.y = -300
		player.get_node("CollisionShape2D").disabled = true
		$Timer.start()

func take_damage(amount: int) -> void :
	player_health -= amount
	player_total_damage_taken += amount
	update_health_label()

func boss_take_damage(amount: int) -> void :
	boss_health -= amount
	boss_total_damage_taken += amount
	update_boss_health_label()
	if boss_node:
		boss_node.boss_health = boss_health

func add_point() -> void :
	score += 1
	player_max_health += 1
	update_health_label()

func update_health_label() -> void :
	if not health_ui or not is_instance_valid(health_ui):
		find_ui_elements()
	if health_ui and is_instance_valid(health_ui):
		health_ui.update_health(player_health, player_max_health)
	else:
		print("⚠️ health_ui is null or invalid!")

func _process(_delta) -> void :
	monitor_health()
	play_time += _delta

func _on_timer_timeout() -> void :
	player_health = player_max_health
	update_health_label()
	player.respawn()

func heal(amount: int) -> void :
	player_health += amount
	if player_health > player_max_health:
		player_health = player_max_health
	update_health_label()

func heal_boss(amount: int) -> void :
	boss_health += amount
	if boss_health > boss_max_health:
		boss_health = boss_max_health
	update_boss_health_label()
	if boss_node:
		boss_node.boss_health = boss_health

func update_boss_health_label() -> void :
	if not boss_health_ui or not is_instance_valid(boss_health_ui):
		find_ui_elements()
	if boss_health_ui and is_instance_valid(boss_health_ui):
		boss_health_ui.max_value = boss_max_health
		boss_health_ui.value = boss_health
	else:
		print("⚠️ boss_health_ui is null! (boss health)")

func show_victory_screen():
	if not victory_screen or not is_instance_valid(victory_screen):
		find_ui_elements()
	if not victory_screen:
		push_error("Victory screen not found")
		return

	save_and_sort_records()

	get_tree().paused = true
	victory_screen.visible = true
	victory_screen.update_display()

func save_and_sort_records():
	var dir = DirAccess.open("user://")
	if not dir:
		DirAccess.make_dir_absolute("user://")

	var file_path: = "user://PlayerRecords.txt"
	var records = []


	var current_record = {
		"time": int(play_time), 
		"deaths": player_deaths, 
		"damage_taken": player_total_damage_taken, 
		"boss_damage": boss_total_damage_taken
	}
	records.append(current_record)


	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		while not file.eof_reached():
			var line = file.get_line()
			if line.strip_edges() == "":
				continue
			var parts = line.split("|")
			if parts.size() >= 4:
				var time_part = parts[0].strip_edges().split(":")
				if time_part.size() >= 3:
					var minutes = int(time_part[1])
					var seconds = int(time_part[2])
					var deaths = int(parts[1].strip_edges().split(":")[1])
					var dmg_taken = int(parts[2].strip_edges().split(":")[1])
					var boss_dmg = int(parts[3].strip_edges().split(":")[1])
					records.append({
						"time": minutes * 60 + seconds, 
						"deaths": deaths, 
						"damage_taken": dmg_taken, 
						"boss_damage": boss_dmg
					})
				else:
					print("⚠️ Skipped malformed time line:", line)
		file.close()


	records.sort_custom(func(a, b):
		return a["time"] < b["time"] or (a["time"] == b["time"] and a["deaths"] < b["deaths"])
	)


	var file = FileAccess.open(file_path, FileAccess.WRITE)
	for record in records:
		var min = record["time"] / 60
		var sec = record["time"] %60
		var line = "Time: %02d:%02d | Deaths: %d | Player Damage Taken: %d | Boss Damage Taken: %d" %\
[min, sec, record["deaths"], record["damage_taken"], record["boss_damage"]]
		file.store_line(line)
	file.close()




func reset_stats():
	Bgm.play()
	player_total_damage_taken = 0
	boss_total_damage_taken = 0
	player_deaths = 0
	play_time = 0.0
	health_ui = null
	boss_health_ui = null
	victory_screen = null
	player = null
	boss_node = null

func _input(event):
	if event.is_action_pressed("respawn"):
		if player:
			player.respawn()
