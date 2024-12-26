extends Behavior
class_name IdleBehavior


@onready var target:Node3D = get_parent()


enum States {
    IN_PROGRESS,
	DONE
}


func _precondition(ai:UtilityAI):
	# Only valid on self
	return ai.agent == target


func choose(ai:UtilityAI):
	ai_states[ai] = States.IN_PROGRESS

	get_tree().create_timer(1.0).timeout.connect(func():
		ai_states[ai] = States.DONE
	)


func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai)


func _process_ai(ai:UtilityAI):
	if ai_states[ai] == States.DONE:
		_complete_behavior(ai)
