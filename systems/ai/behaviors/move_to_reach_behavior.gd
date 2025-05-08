extends Behavior
class_name MoveToReachBehavior


func _precondition(ai:UtilityAI):
	return not ai.agent_can_reach(global_position)


func _process_ai(ai:UtilityAI):
	if ai.agent_can_reach(global_position):
		ai.agent.stop_move_to()
		_complete_behavior(ai)
	else:
		ai.agent.move_to(global_position)
