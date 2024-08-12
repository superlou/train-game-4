extends Interactable
class_name Carryable


@onready var body:RigidBody3D = get_parent()
var is_carried := false
var carry_target:Node3D = null

# var force_pid := PIDController3.new()
# var torque_pid := PIDController3.new()
var pickup_rot_y := 0.0


func _ready():
	interacted.connect(on_interacted)
	# force_pid.set_k_all(100., 1., 70.)
	# torque_pid.set_k_all(2., 0.01, 0.5)


func on_interacted(interactor: Interactor):
	if is_carried:
		drop(interactor)
	else:
		pick_up(interactor)


func pick_up(interactor: Interactor):
	interactor.set_carried(body)
	carry_target = interactor.carry_joint
	is_carried = true

	# force_pid.reset()
	# torque_pid.reset()

	# force_pid.set_scale_all(body.mass)
	# torque_pid.set_scale_all(body.mass)  # Should be inertia?
	pickup_rot_y = global_rotation.y - carry_target.global_rotation.y


func drop(interactor: Interactor):
	interactor.set_carried(null)
	carry_target = null
	is_carried = false

	# Not sure why this can_sleep hack is necessary
	body.can_sleep = false
	await get_tree().process_frame
	body.sleeping = false
	body.can_sleep = true
	


func _physics_process(delta):
	if is_carried:
		# var target_pos := carry_target.global_position
		# var pos_offset := global_position - target_pos
		# var force := force_pid.run(pos_offset, Vector3.ZERO, delta)

		# var rot_offset := global_rotation - carry_target.global_rotation
		# var y_error := rot_offset.y - pickup_rot_y
		# y_error = wrapf(y_error, -PI, PI)

		# print()
		# print("carryable: ", global_rotation)
		# print("carry_target: ", carry_target.global_rotation)
		# print("pickup_rot_y:", pickup_rot_y)
		# print(y_error)

		# var torque := torque_pid.run(
		# 	Vector3(global_rotation.x, y_error, global_rotation.z),
		# 	Vector3.ZERO,
		# 	delta
		# )

		# print(torque)
		# body.apply_central_force(force)
		# body.apply_torque(torque)
		body.linear_velocity = (carry_target.global_position - global_position) * 50
		body.angular_velocity = calc_angular_velocity(body.global_basis, carry_target.global_basis) * 10	


# From https://github.com/babypandabear3/godot4_portal_style_grab/blob/main/grabable/grabable_box.gd
func calc_angular_velocity(from_basis: Basis, to_basis: Basis) -> Vector3:
	var q1 = from_basis.get_rotation_quaternion()
	var q2 = to_basis.get_rotation_quaternion()

	# Quaternion that transforms q1 into q2
	var qt:Quaternion = q2 * q1.inverse()

	# Angle from quaternion
	var angle = 2 * acos(qt.w)

	# There are two distinct quaternions for any orientation.
	# Ensure we use the representation with the smallest angle.
	if angle > PI:
		qt = -qt
		angle = TAU - angle
	
	# Prevent division by zero
	if angle < 0.0001:
		return Vector3.ZERO
	
	# Axis from quaternion
	var axis = Vector3(qt.x, qt.y, qt.z) / sqrt(1 - qt.w * qt.w)
	
	return axis * angle