extends BTAction
class_name Phase2MeteorAttack

var boss_body: CharacterBody2D
var animation_sprite: AnimatedSprite2D
var spawn_point: Marker2D
var meteor_scene: PackedScene
var player: Node2D

func _setup():
    boss_body = agent as CharacterBody2D
    if not boss_body:
        return

    animation_sprite = boss_body.get_node("AnimatedSprite2D")
    spawn_point = boss_body.get_node("MeteorSpawnPoint")
    meteor_scene = preload("res://boss/meteor.tscn")
    player = boss_body.get_tree().get_first_node_in_group("player") as Node2D

func _tick(delta: float) -> Status:
    if not spawn_point or not meteor_scene or not player:
        return FAILURE


    var original_animation = animation_sprite.animation


    animation_sprite.play("meteor")


    _spawn_meteor()


    var tween = boss_body.create_tween()
    tween.tween_callback(Callable(animation_sprite, "play").bind(original_animation)).set_delay(0.5)


    return SUCCESS

func _spawn_meteor():

    var meteor = meteor_scene.instantiate()
    meteor.global_position = spawn_point.global_position
    meteor.target_position = player.global_position

    if meteor.has_node("AnimatedSprite2D"):
        var m_sprite = meteor.get_node("AnimatedSprite2D")
        m_sprite.flip_h = (player.global_position.x < spawn_point.global_position.x)

    boss_body.get_parent().add_child(meteor)
