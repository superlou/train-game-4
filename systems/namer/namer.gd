extends Node


const STATION_NAME_MODEL := preload("res://systems/namer/station_name_markov.json")

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		

func generate_station_name() -> String:
	return generate(
		STATION_NAME_MODEL.data.transition_table,
		int(STATION_NAME_MODEL.data.order)
	)


func generate(transition_table, order:int) -> String:
	var word := "^".repeat(order)
	var i := order

	while word[-1] != "$":
		word += pick_next(transition_table, word.right(order))
		i += 1

		if i > 100:
			break # Emergency exit

	return word.substr(order, len(word) - order - 1)


func pick_next(transition_table, state:String) -> String:
	var state_transition = transition_table[state]
	var tokens = state_transition[0]
	var weights = PackedFloat32Array(state_transition[1])
	return tokens[rng.rand_weighted(weights)]