extends Behavior
class_name EatHeldBehavior


@onready var target:Node3D = get_parent()


enum States {
	IN_PROGRESS,
	CONSUMED,
}


func _precondition(ai:UtilityAI):
	return ai.agent.is_holding(target)


func choosen_by(ai:UtilityAI):
	ai_states[ai] = States.IN_PROGRESS
	ai.agent.eat(target)
	await ai.agent.consumed_held
	ai_states[ai] = States.CONSUMED


func _process_ai(ai:UtilityAI):
	if ai_states[ai] == States.CONSUMED:
		var offer := make_offer_to(ai)
		ai.motives.add_on(offer.motives)
		target.queue_free()
