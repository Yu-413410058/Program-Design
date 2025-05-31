extends Control

@onready var health_label: Label = $health_label
@onready var boss_health_label: Label = $boss_health_label

func _ready():
	add_to_group("health_ui")

func update_health(current: int, max: int) -> void :
	health_label.text = "❤️ %d / %d" % [current, max]

func update_boss_health(current: int, max: int) -> void :
	boss_health_label.text = "Boss: %d / %d" % [current, max]
