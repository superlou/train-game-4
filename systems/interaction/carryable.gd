extends Interactable
class_name Carryable


var is_carried := false
var original_parent = null


func _ready():
	interacted.connect(on_interacted)


func on_interacted(interactor: Interactor):
	if is_carried:
		drop(interactor)
	else:
		pick_up(interactor)


func pick_up(interactor: Interactor):
	# todo FIX SUPER HACK.
	# todo Store original parent so that objects can be dropped
	var carry_point: Marker3D = interactor.get_parent().get_node("CarryPoint")
	original_parent = get_parent().get_parent()
	get_parent().reparent(carry_point)
	get_parent().gravity_scale = 0
	interactor.set_carried(get_parent())
	is_carried = true


func drop(interactor: Interactor):
	get_parent().reparent(original_parent)
	original_parent = null
	get_parent().gravity_scale = 1
	interactor.set_carried(null)
	is_carried = false
