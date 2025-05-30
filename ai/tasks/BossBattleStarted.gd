extends BTCondition
class_name BossBattleStarted

func _check() -> bool:
	var boss = agent as Boss
	if boss:
		return boss.battle_started
	return false
