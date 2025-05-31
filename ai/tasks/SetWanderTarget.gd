
@tool
extends BTAction

func _tick(delta: float) -> Status:
    var boss = agent as Boss
    boss.target_position = boss.get_random_wander_position()
    return SUCCESS
