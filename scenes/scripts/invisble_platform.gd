extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

var visible_state: = true

func _ready():
    timer.connect("timeout", Callable(self, "_on_timer_timeout"))
    timer.start()

func _on_timer_timeout():
    visible_state = !visible_state
    animated_sprite_2d.visible = visible_state
    timer.start()
