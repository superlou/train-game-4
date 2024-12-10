extends Behavior
class_name MoveToReachBehavior


enum MoveToReachBehaviorState {
	MOVING
}


func _precondition(ai:UtilityAI):
	return not ai.agent_can_reach(global_position)


func choose(ai:UtilityAI):
	ai_states[ai] = MoveToReachBehaviorState.MOVING


func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai)


func _process_ai(ai:UtilityAI):
	if ai.agent_can_reach(global_position):
		ai.agent.stop_move_to()
		_complete_behavior(ai)
	else:
		# ai.move_to.emit(global_position)
		ai.agent.move_to(global_position)
