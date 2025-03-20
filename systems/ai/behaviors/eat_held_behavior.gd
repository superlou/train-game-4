extends Behavior
class_name EatHeldBehavior


@onready var target:Node3D = get_parent()


enum States {
	IN_PROGRESS,
	CONSUMED,
}


func _precondition(ai:UtilityAI):
	return ai.agent.is_holding(target)


func choose(ai:UtilityAI):
	ai_states[ai] = States.IN_PROGRESS
	ai.agent.consumed_held.connect(func(): ai_states[ai] = States.CONSUMED)
	ai.agent.eat(target)


func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai)


func _process_ai(ai:UtilityAI):
	# print(ai_states[ai])
	if ai_states[ai] == States.CONSUMED:
		var offer := make_offer_to(ai)
		ai.motives.add_on(offer.motives)
		target.queue_free()
