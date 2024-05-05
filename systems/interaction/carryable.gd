extends Interactable
class_name Carryable


@onready var body:RigidBody3D = get_parent()
var is_carried := false


func _ready():
	interacted.connect(on_interacted)


func on_interacted(interactor: Interactor):
	if is_carried:
		drop(interactor)
	else:
		pick_up(interactor)


func pick_up(interactor: Interactor):
	var carry_joint:Generic6DOFJoint3D = interactor.carry_joint
	body.global_position = carry_joint.global_position
	carry_joint.node_b = body.get_path()
	interactor.set_carried(body)
	is_carried = true



func drop(interactor: Interactor):
	var carry_joint = interactor.carry_joint
	carry_joint.node_b = ^""
	interactor.set_carried(null)
	is_carried = false
