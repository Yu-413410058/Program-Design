
@tool
extends BTCondition


func _tick(delta: float) -> Status:
    var boss = agent as Boss

    if boss.target_position == Vector2.ZERO or boss.global_position.distance_to(boss.target_position) < 20.0:
        return SUCCESS
    return FAILURE
