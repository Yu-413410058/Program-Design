extends Control

@onready var time_value: Label = $UI / GridContainer / TimeValue
@onready var death_value: Label = $UI / GridContainer / DeathValue
@onready var damage_taken_value: Label = $UI / GridContainer / DamageTakenValue
@onready var boss_taken_damage_value: Label = $UI / GridContainer / BossTakenDamageValue
@onready var music: AudioStreamPlayer2D = $VictoryMusic

func _ready() -> void :
	add_to_group("victory_screen")
	set_process_input(true)
	process_mode = Node.PROCESS_MODE_ALWAYS
	modulate.a = 0.0
	visible = false

func update_display():
	music.volume_db = -40
	music.play()
	create_tween().tween_property(music, "volume_db", 0, 1.5)
	var total_seconds = int(GameManager.play_time)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	time_value.text = "%02d:%02d" % [minutes, seconds]
	death_value.text = str(GameManager.player_deaths)
	damage_taken_value.text = str(GameManager.player_total_damage_taken)
	boss_taken_damage_value.text = str(GameManager.boss_total_damage_taken)

	modulate.a = 0.0
	visible = true
	create_tween().tween_property(self, "modulate:a", 1.0, 1.5)

func _input(event):
	if not visible:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				var tween = create_tween()
				tween.tween_property(music, "volume_db", -40, 1.5)
				tween.tween_callback(Callable(music, "stop"))

				visible = false
				GameManager.reset_stats()
				get_tree().paused = false
				set_process_input(false)
				get_tree().reload_current_scene()
			KEY_E:
				get_tree().quit()
