
@tool
extends BTCondition

func _tick(delta: float) -> Status:
    var boss = agent as Boss
    if boss.is_player_detected():
        return SUCCESS
    return FAILURE
