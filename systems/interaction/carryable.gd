extends Marker3D
class_name Carryable

@export var enabled := true

@onready var body:RigidBody3D = get_parent()
var carry_target:Node3D = null

var pickup_rot_y := 0.0


func interact(interactor: Interactor):
	if not enabled or not interactor.carrier:
		return

	if carry_target:
		_drop(interactor.carrier)
	else:
		_pick_up(interactor.carrier)


func _pick_up(carrier: Carrier):
	carrier.carryable = self
	carry_target = carrier
	pickup_rot_y = global_rotation.y - carry_target.global_rotation.y


func _drop(carrier: Carrier):
	carrier.carryable = null
	carry_target = null
	

func _physics_process(_delta):
	if carry_target:
		body.force_linear_velocity(
			(carry_target.global_position - global_position) * 20
		)
		body.force_angular_velocity(
			calc_angular_velocity(body.global_basis, carry_target.global_basis) * 20
		)


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


func _on_interactable_interacted(interactor: Interactor) -> void:
	pass # Replace with function body.
