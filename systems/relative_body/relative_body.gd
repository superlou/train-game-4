extends RigidBody3D
class_name RelativeBody


@export var trainset: Trainset


func _physics_process(_delta):
	if not trainset:
		return

	# todo This isn't quite right for round bodies. They still roll
	# a little during accelerations.
	apply_central_force(mass * -trainset.head_accel)
