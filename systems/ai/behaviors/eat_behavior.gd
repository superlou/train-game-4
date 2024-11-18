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


func choose(agent):
	agent_states[agent] = EatBehaviorState.MOVE_TO
	var action = MoveToAction.new()
	action.position = global_position
	agent_actions[agent] = action


func get_action_for(agent):
	if agent in agent_actions:
		return agent_actions[agent]
	else:
		return null


func _process(_delta:float):
	for agent in agent_states.keys():
		_process_agent(agent)


func _process_agent(agent):
	if agent_states[agent] == EatBehaviorState.MOVE_TO:
		if _agent_can_reach(agent):
			agent_states[agent] = EatBehaviorState.STOP
			agent_actions[agent] = StopAction.new()


func _agent_can_reach(agent):
	# todo This could be broken into different kinds of reaching, e.g., agent_can_reach_kneeling
	var pos1 = agent.global_position
	pos1.y = 0.0

	var pos2 := global_position
	pos2.y = 0.0

	return pos1.distance_to(pos2) < 0.6
