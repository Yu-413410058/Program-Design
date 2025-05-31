extends BTCondition

func _tick(delta: float) -> Status:
	var boss = agent as Boss
	if boss and boss.current_phase == 2:
		return SUCCESS
	return FAILURE
