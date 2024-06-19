extends RigidBody3D
class_name RelativeBody


func _physics_process(_delta):
	# todo This isn't quite right for round bodies. They still roll
	# a little during accelerations.
	apply_central_force(mass * RelativeWorld.accel)
