extends Area2D

@onready var battlemusic: AudioStreamPlayer = $AudioStreamPlayer
@onready var battlemusic_2: AudioStreamPlayer = $AudioStreamPlayer2

var player_inside := false
var music1_played := false
var music2_played := false

func _ready():
	set_process(true)

func _on_body_entered(body: Node) -> void:
	Bgm.stop()
	if body.is_in_group("player"):
		player_inside = true
		print("Player entered battle area")
		# Trigger music1 when player enters for the first time
		if not music1_played:
			battlemusic.play()
			music1_played = true
			print("Battle music started")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = false
		print("Player exited battle area")

func _process(_delta: float) -> void:
	if music2_played:
		return
	
	var boss = get_node_or_null("/root/Game/boss")
	if boss and boss.current_phase == 2:
		if battlemusic.playing:
			battlemusic.stop()
		if not battlemusic_2.playing:
			battlemusic_2.play()
			music2_played = true
			print("Phase 2 music started")
