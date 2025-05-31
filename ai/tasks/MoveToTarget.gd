@tool
extends BTAction
class_name MoveToTarget

@export var speed_multiplier: float = 1.0
@export var tolerance: float = 10.0

func _tick(delta: float) -> Status:
    var boss = agent as Boss
    if not boss.target_position:
        return FAILURE

    var direction = (boss.target_position - boss.global_position).normalized()
    var speed = boss.wander_speed * speed_multiplier


    boss.velocity.x = direction.x * speed
    boss.move_and_slide()


    var distance = boss.global_position.distance_to(boss.target_position)
    if distance < tolerance:
        boss.velocity.x = 0
        return SUCCESS

    return RUNNING
