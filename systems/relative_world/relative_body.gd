extends RigidBody3D
class_name RelativeBody


var force_linear_velocities:Array[Vector3] = []
var force_angular_velocities:Array[Vector3] = []


func _physics_process(_delta):
	# todo This isn't quite right for round bodies. They still roll
	# a little during accelerations.
	apply_central_force(mass * RelativeWorld.accel)


func sum(accum, number):
	return accum + number


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# print(is_carried)
	# if is_carried:
	# 	state.linear_velocity = carry_linear_velocity
	# 	state.angular_velocity = carry_angular_velocity
	# 	print(state.linear_velocity)

	if len(force_linear_velocities) > 0:
		var forced:Vector3 = force_linear_velocities.reduce(sum, Vector3.ZERO)
		force_linear_velocities = []
		state.linear_velocity = forced

	if len(force_angular_velocities) > 0:
		var forced:Vector3 = force_angular_velocities.reduce(sum, Vector3.ZERO)
		force_angular_velocities = []
		state.angular_velocity = forced


func force_linear_velocity(velocity:Vector3):
	force_linear_velocities.append(velocity)


func force_angular_velocity(velocity:Vector3):
	force_angular_velocities.append(velocity)