extends Behavior
class_name EatHeldBehavior


@onready var target:Node3D = get_parent()


enum States {
    IN_PROGRESS
}


func _precondition(ai:UtilityAI):
	return ai.agent.is_holding(target)


func choose(ai:UtilityAI):
	ai_states[ai] = States.IN_PROGRESS


func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai)


func _process_ai(ai:UtilityAI):
	pass
