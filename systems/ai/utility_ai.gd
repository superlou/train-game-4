extends Node
class_name UtilityAI


@onready var agent:Node = get_node("..")
@export var motives:UtilityMotives

signal move_to(pos: Vector3)
signal stop_move_to

var known_behaviors:Array[Behavior] = []
var current_behavior:Behavior = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _pick_behavior() -> Behavior:
	# todo Known behaviors should be based on sensors, location, or something
	var behaviors := get_tree().get_nodes_in_group("behavior")
	known_behaviors.assign(behaviors)
	return known_behaviors.pick_random()  # todo utility AI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not current_behavior:
		current_behavior = _pick_behavior()
		current_behavior.choose(agent)
		return

	var action = current_behavior.get_action_for(agent)

	if action is MoveToAction:
		move_to.emit(action.position)
	elif action is StopAction:
		stop_move_to.emit()
