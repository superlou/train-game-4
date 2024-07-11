extends Interactable
class_name Carryable


@onready var body:RigidBody3D = get_parent()
var is_carried := false
var carrier:Node3D = null

var force_pid_x := PIDController.new()
var force_pid_y := PIDController.new()
var force_pid_z := PIDController.new()

var torque_pid_y := PIDController.new()
var pickup_rot_y := 0.0


func _ready():
	interacted.connect(on_interacted)

	var kp := 100.0
	var ki := 1.0
	var kd := 70.0
	force_pid_x.set_k(kp, ki, kd)
	force_pid_y.set_k(kp, ki, kd)
	force_pid_z.set_k(kp, ki, kd)

	torque_pid_y.set_k(2., 0.01, 0.5)


func on_interacted(interactor: Interactor):
	if is_carried:
		drop(interactor)
	else:
		pick_up(interactor)


func pick_up(interactor: Interactor):
	interactor.set_carried(body)
	carrier = interactor.carry_joint
	is_carried = true

	force_pid_x.reset()
	force_pid_y.reset()
	force_pid_z.reset()
	torque_pid_y.reset()

	force_pid_x.set_scale(body.mass)
	force_pid_y.set_scale(body.mass)
	force_pid_z.set_scale(body.mass)
	torque_pid_y.set_scale(body.mass)  # Should be inertia
	pickup_rot_y = carrier.global_rotation.y


func drop(interactor: Interactor):
	body.sleeping = false
	interactor.set_carried(null)
	carrier = null
	is_carried = false


func _physics_process(delta):
	if is_carried:
		var target_pos := carrier.global_position
		var offset := global_position - target_pos

		var force := Vector3(
			force_pid_x.run(offset.x, 0., delta),
			force_pid_y.run(offset.y, 0., delta),
			force_pid_z.run(offset.z, 0., delta)
		)

		var rot_offset := global_rotation - carrier.global_rotation
		var y_error := rot_offset.y - pickup_rot_y
		
		while y_error >= PI:
			y_error -= 2 * PI
		while y_error < -PI:
			y_error += 2 * PI

		print()
		print(body.global_rotation)
		print(carrier.global_rotation)
		print(y_error)

		var torque := Vector3(
			0.,
			torque_pid_y.run(y_error, 0.0, delta),
			0.,
		)

		body.apply_central_force(force)
		body.apply_torque(torque)
		# print(force)
		# print(torque)
