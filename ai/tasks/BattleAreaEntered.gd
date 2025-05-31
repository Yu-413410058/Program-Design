extends BTCondition
class_name CheckPlayerInBattleArea

func _tick(delta: float) -> Status:
	var game = agent.get_tree().get_current_scene()

	if not game:
		print("game scene not found")
		return FAILURE

	var battle_area = game.get_node("BattleArea")
	if not battle_area:
		print("BattleArea not found")
		return FAILURE

	if battle_area.player_inside:
		return SUCCESS
	else:
		print("Player is outside battle area")
		return FAILURE
