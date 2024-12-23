extends Behavior
class_name PickUpBehavior


@onready var target:Node3D = get_parent()


enum States {
    IN_PROGRESS
}


func _precondition(ai:UtilityAI):
	return (
		ai.agent_can_reach(global_position)
		and ai.agent.has_method("pick_up")
		and not ai.agent.is_holding(target)
	)


func choose(ai:UtilityAI):
	ai_states[ai] = States.IN_PROGRESS
	ai.agent.pick_up(target)


func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai)


func _process_ai(ai:UtilityAI):
	if ai.agent.is_holding(target):
		_complete_behavior(ai)
