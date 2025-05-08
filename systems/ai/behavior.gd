extends Node3D
class_name Behavior

@export var enabled := true
@export var offer_motives:UtilityMotives
@export var base_motives_behavior:Behavior

var ai_states = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("behavior")


func _process(_delta:float):
	for ai in ai_states.keys():
		_process_ai(ai)


func _process_ai(_ai:UtilityAI):
	pass


func _precondition(_ai:UtilityAI) -> bool:
	""" Override to specify a precondition to consider a behavior"""
	return true


func _build_offer() -> UtilityOffer:
	""" Override to have dynamic offer logic """
	var offer := UtilityOffer.new()
	offer.motives = offer_motives
	offer.global_position = global_position
	return offer


func make_offer_to(ai:UtilityAI) -> UtilityOffer:
	if (not enabled) or (not _precondition(ai)):
		# Return null if this behavior shouldn't be executed.
		return null

	var offer := _build_offer()
	
	# todo This isn't completely thought through. It might be that
	# offers calculated in the wrong order might get the wrong results.
	if not offer.motives and base_motives_behavior:
		offer.motives = base_motives_behavior.offer_motives
	elif base_motives_behavior:
		offer.motives.add_on(base_motives_behavior.offer_motives)
	elif not offer.motives:
		offer.motives = UtilityMotives.new()
	
	return offer


func chosen_by(ai:UtilityAI):
	""" Override with behavior actions """
	# Register the AI with no state information
	ai_states[ai] = null


func _complete_behavior(ai:UtilityAI):
	ai_states.erase(ai)
	ai.current_behavior = null