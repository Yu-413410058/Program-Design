extends Area2D

@onready var battlemusic: AudioStreamPlayer = $AudioStreamPlayer
var player_inside := false
var music_played := false  # Prevent retriggering

func _ready():
	set_process(true)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = true
		print("Player entered battle area")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = false
		print("Player exited battle area")

func _process(_delta: float) -> void:
	if music_played:
		return
	
	var boss = get_node_or_null("/root/Game/boss")
	if boss.current_phase == 2 and player_inside:
		if not battlemusic.playing:
			battlemusic.play()
			music_played = true
			print("Battle music triggered!")
