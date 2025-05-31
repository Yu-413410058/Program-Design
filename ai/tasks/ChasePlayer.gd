
@tool
extends BTAction
class_name ChasePlayer

@export var chase_speed: float = 100.0

func _tick(delta: float) -> Status:
    var boss = agent as Boss

    if not boss.player:
        boss.velocity.x = 0
        return FAILURE

    var direction = (boss.player.global_position - boss.global_position).normalized()


    boss.velocity.x = direction.x * chase_speed
    boss.move_and_slide()

    return RUNNING
