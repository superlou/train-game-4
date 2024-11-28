extends Behavior
class_name PickUpBehavior


enum States {
    IN_PROGRESS
}


func _precondition(ai:UtilityAI):
	return ai.agent_can_reach(global_position)


func choose(ai:UtilityAI):
	ai_states[ai] = States.IN_PROGRESS
	ai.pick_up.emit(get_parent())


func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai)


func _process_ai(ai:UtilityAI):
	pass
