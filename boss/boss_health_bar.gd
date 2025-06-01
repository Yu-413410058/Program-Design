extends Control

@onready var bar = $ProgressBar

func set_health(current, max):
	bar.max_value = max
	bar.value = current
