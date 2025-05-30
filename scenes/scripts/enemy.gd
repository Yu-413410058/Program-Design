extends Node2D

const speed = 60
const gravity = 600
const jump_force = -150
const death_delay = 0.5

@onready var ray_cast_left: RayCast2D = $ray_cast_left
@onready var ray_case_right: RayCast2D = $ray_case_right
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var direction = -1
var health = 1
var velocity = Vector2.ZERO
var is_dying = false

func _process(delta):
	if is_dying:
		# Only vertical movement when dying (small jump + fall)
		position.y += velocity.y * delta
		velocity.y += gravity * delta
	else:
		# Normal patrol movement
		if ray_case_right.is_colliding():
			direction = -1
			animated_sprite_2d.flip_h = false
		if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = true
		position.x += direction * speed * delta

func take_damage(amount: int):
	health -= amount
	if health <= 0 and not is_dying:
		die()

func die():
	GameManager.add_point()
	is_dying = true
	velocity.y = jump_force
	await get_tree().create_timer(0.5).timeout
	queue_free()
