extends Behavior
class_name EatBehavior


enum EatBehaviorState {
	MOVE_TO,
	STOP,
	DROP_HELD,
	PICK_UP,
	EAT,
	DONE
}


func choose(ai:UtilityAI):
	ai_states[ai] = EatBehaviorState.MOVE_TO
	

func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai, ai_states[ai])


func _process_ai(ai:UtilityAI, state:EatBehaviorState):
	# Update
	match state:
		EatBehaviorState.MOVE_TO:
			if _agent_can_reach(ai.agent):
				state = EatBehaviorState.STOP

	# Act
	match state:
		EatBehaviorState.MOVE_TO:
			ai.move_to.emit(global_position)
		EatBehaviorState.STOP:
			ai.stop_move_to.emit()


func _agent_can_reach(agent):
	# todo This could be broken into different kinds of reaching, e.g., agent_can_reach_kneeling
	var pos1 = agent.global_position
	pos1.y = 0.0

	var pos2 := global_position
	pos2.y = 0.0

	return pos1.distance_to(pos2) < 0.6
