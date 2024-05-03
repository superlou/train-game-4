extends Interactable
class_name Carryable


func _ready():
	interacted.connect(do_something)


func do_something(interactor: Interactor):
	# todo FIX SUPER HACK.
	# todo Store original parent so that objects can be dropped
	var carry_point: Marker3D = interactor.get_parent().get_node("CarryPoint")
	get_parent().reparent(carry_point)
	get_parent().gravity_scale = 0