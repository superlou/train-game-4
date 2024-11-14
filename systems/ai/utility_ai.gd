extends Node
class_name UtilityAI


@onready var agent:Node = get_node("..")

signal picked_movement_goal(pos: Vector3)

enum AIState {
	IDLE,
	MOVING,
	BEHAVING,
}

var known_behaviors:Array[Behavior] = []
var target_behavior:Behavior = null
var state := AIState.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _pick_behavior() -> Behavior:
	var behaviors := get_tree().get_nodes_in_group("behavior")
	known_behaviors.assign(behaviors)
	return known_behaviors.pick_random()  # todo utility AI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if state == AIState.IDLE:
		target_behavior = _pick_behavior()
		state = AIState.MOVING
		picked_movement_goal.emit(target_behavior.global_position)
