extends Node
class_name UtilityAI


@export var agent:Node3D
@export var motives:UtilityMotives
@export var weights:UtilityWeights


var known_behaviors:Array[Behavior] = []
var current_behavior:Behavior = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _pick_behavior() -> Behavior:
	# todo Known behaviors should be based on sensors, location, memory, or something
	var behaviors := get_tree().get_nodes_in_group("behavior")
	known_behaviors.assign(behaviors)

	# Get all offers, discard null offers, and calculate score.
	# Results in array with elements [behavior, offer, score]
	var behavior_offer_scores := (known_behaviors
		.map(func(bvr): return [bvr, bvr.make_offer_to(self)])
		.filter(func(bvr_offer): return bvr_offer[1] != null)
		.map(func(bvr_offer): return [bvr_offer[0], bvr_offer[1], _calc_score(bvr_offer[1])])
	)

	# Sort by descending score
	behavior_offer_scores.sort_custom(func(a, b): return a[2] > b[2])

	# todo If no behaviors are available, pick idle.
	# todo Add some randomness to selecting behaviors
	return behavior_offer_scores[0][0]


func _calc_score(offer) -> float:
	return (
		offer.motives.fullness * weights.fullness.sample_baked(motives.fullness) +
		offer.motives.energy * weights.energy.sample_baked(motives.energy) +
		offer.motives.security * weights.security.sample_baked(motives.security) +
		offer.motives.fun * weights.fun.sample_baked(motives.fun) +
		offer.motives.health * weights.health.sample_baked(motives.health) +
		offer.motives.space * weights.space.sample_baked(motives.space)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not current_behavior:
		current_behavior = _pick_behavior()
		current_behavior.choose(self)
		print("Picked behavior: ", current_behavior)


func agent_can_reach(target_position:Vector3):
	# todo This could be broken into different kinds of reaching, e.g., agent_can_reach_kneeling
	var pos1 = agent.global_position
	pos1.y = 0.0

	var pos2 := target_position
	pos2.y = 0.0

	return pos1.distance_to(pos2) < 1.0
