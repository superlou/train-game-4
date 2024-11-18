extends Node3D
class_name Behavior

@export var enabled := true
@export var offer_motives:UtilityMotives

var agent_states = {}
var agent_actions = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("behavior")


func _calc_offer() -> UtilityOffer:
	""" Override to have dynamic offer logic """
	var offer := UtilityOffer.new()
	offer.motives = offer_motives
	offer.global_position = global_position
	offer.duration = 0.0
	return offer


func advertises() -> UtilityOffer:
	if not enabled:
		# Return null if this behavior shouldn't be executed.
		return null

	return _calc_offer()


func choose(agent):
	""" Override with behavior actions """
	print("%s picked unimplemented behavior %s." % [agent, self])
