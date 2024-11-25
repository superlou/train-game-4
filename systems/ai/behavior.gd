extends Node3D
class_name Behavior

@export var enabled := true
@export var offer_motives:UtilityMotives
@export var base_motives_behavior:Behavior

var ai_states = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("behavior")


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
	
	if not offer.motives and base_motives_behavior:
		offer.motives = base_motives_behavior.offer_motives
	elif base_motives_behavior:
		offer.motives.add_base_motives(base_motives_behavior.offer_motives)
	else:
		offer.motives = UtilityMotives.new()
	
	return offer


func choose(agent):
	""" Override with behavior actions """
	print("%s picked unimplemented behavior %s." % [agent, self])


func _complete_behavior(ai:UtilityAI):
	ai_states.erase(ai)
	ai.current_behavior = null