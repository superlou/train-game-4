extends Behavior
class_name IdleBehavior


@onready var target:Node3D = get_parent()


func _precondition(ai:UtilityAI):
	# Only valid on self
	return ai.agent == target


func choosen_by(ai:UtilityAI):
	ai_states[ai] = null
	await get_tree().create_timer(1.0).timeout
	_complete_behavior(ai)
