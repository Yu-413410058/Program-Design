# CheckNeedNewTarget.gd
@tool
extends BTCondition

	
func _tick(delta: float) -> Status:
	var boss = agent as Boss
	# Check if we don't have a target or we're close to current target
	if boss.target_position == Vector2.ZERO or boss.global_position.distance_to(boss.target_position) < 20.0:
		return SUCCESS
	return FAILURE
