extends Interactable
class_name Carryable


@onready var body:RigidBody3D = get_parent()
var is_carried := false
var carrier:Node3D = null

var force_pid := PIDController3.new()
var torque_pid := PIDController3.new()
var pickup_rot_y := 0.0


func _ready():
	interacted.connect(on_interacted)
	force_pid.set_k_all(100., 1., 70.)
	torque_pid.set_k_all(2., 0.01, 0.5)


func on_interacted(interactor: Interactor):
	if is_carried:
		drop(interactor)
	else:
		pick_up(interactor)


func pick_up(interactor: Interactor):
	interactor.set_carried(body)
	carrier = interactor.carry_joint
	is_carried = true

	force_pid.reset()
	torque_pid.reset()

	force_pid.set_scale_all(body.mass)
	torque_pid.set_scale_all(body.mass)  # Should be inertia?
	pickup_rot_y = global_rotation.y - carrier.global_rotation.y


func drop(interactor: Interactor):
	interactor.set_carried(null)
	carrier = null
	is_carried = false
	body.sleeping = false


func _physics_process(delta):
	if is_carried:
		var target_pos := carrier.global_position
		var pos_offset := global_position - target_pos
		var force := force_pid.run(pos_offset, Vector3.ZERO, delta)

		var rot_offset := global_rotation - carrier.global_rotation
		var y_error := rot_offset.y - pickup_rot_y
		y_error = wrapf(y_error, -PI, PI)

		print()
		print("carryable: ", global_rotation)
		print("carrier: ", carrier.global_rotation)
		print("pickup_rot_y:", pickup_rot_y)
		print(y_error)

		var torque := torque_pid.run(
			Vector3(0, y_error, 0),
			Vector3.ZERO,
			delta
		)

		body.apply_central_force(force)
		body.apply_torque(torque)
