extends Behavior
class_name AppealBehavior


enum States {
	MOVING,
	APPEALING,
}


func _precondition(ai:UtilityAI):
	# Any agent with a backstory that wants to appeal can do this
	# if they want it. This is regardless of if the player interacts
	# with them.
	return ai.agent.needs_to_appeal()


func chosen_by(ai:UtilityAI):
	ai_states[ai] = States.MOVING


func _process_ai(ai:UtilityAI):
	var state:States = ai_states[ai]

	match state:
		States.MOVING:
			if ai.agent_can_reach(global_position):
				ai.agent.stop_move_to()
				ai_states[ai] = States.APPEALING
			else:
				ai.agent.move_to(global_position)
		States.APPEALING:
			ai.agent.look_to(global_position)
