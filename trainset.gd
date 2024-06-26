class_name Trainset
extends Node3D

@export var head_velocity := Vector3.ZERO
@export var acceleration := 5.0
@export var breaking := 15.0

@export var mass := 30_000.0 # todo Replace with calculation from pulled cars
@export var rolling_mu := 0.05
@export var static_mu := 0.15
@export var max_thrust := 30_000.0
@export_range(-1.0, 1.0) var throttle := 0.0

var velocity_pid := PIDController.new()
var velocity_target := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity_pid.ki = 0.001


func _calc_drag(flow_vel: float) -> float:
	const c_d := 0.82
	const reference_area := 3.65 * 2.74 # m2
	const rho := 1.2 # kg/m3
	return 0.5 * rho * (flow_vel ** 2) * c_d * reference_area


# Physics priority needs to be set lower than other nodes otherwise
# velocity between the train and other objects won't be quite right
# when accelerating.
func _physics_process(delta):
	var head_accel := Vector3.ZERO

	if Input.is_action_pressed("accelerate_right"):
		velocity_target += 5.0 * delta
	
	if Input.is_action_pressed("accelerate_left"):
		velocity_target -= 5.0 * delta

	if Input.is_action_pressed("apply_break"):
		velocity_target = 0.0
	
	throttle = velocity_pid.run(head_velocity.x, velocity_target, delta)

	throttle = clampf(throttle, -1.0, 1.0)

	# todo This should all be vector math
	var thrust := throttle * max_thrust

	var drag := _calc_drag(head_velocity.x)

	if head_velocity.x > 0.0:
		head_accel.x = (thrust - drag - rolling_mu * mass) / mass
	elif head_velocity.x < -0.0:
		head_accel.x = (thrust + drag + rolling_mu * mass) / mass
	else:
		if thrust > 0 and thrust - static_mu * mass > 0:
			head_accel.x = (thrust - static_mu * mass) / mass
		elif thrust < 0 and thrust + static_mu * mass < 0:
			head_accel.x = (thrust + static_mu * mass) / mass

	# if Input.is_action_pressed("accelerate_right"):
	# 	head_accel += Vector3.RIGHT * acceleration
	
	# if Input.is_action_pressed("accelerate_left"):
	# 	head_accel += -Vector3.RIGHT * acceleration

	# if Input.is_action_pressed("apply_break"):
	# 	if head_velocity.length() <= breaking * delta:
	# 			head_accel = -head_velocity / delta
	# 	elif head_velocity.x > 0:
	# 		head_accel += -Vector3.RIGHT * breaking
	# 	elif head_velocity.x < 0:
	# 		head_accel += Vector3.RIGHT * breaking

	head_velocity += head_accel * delta
	RelativeWorld.accel = -head_accel

	# print(head_accel)
	# print("throttle: ", throttle)
	# print("thrust: ", thrust)
	# print(thrust - static_mu * mass)
	print(head_velocity)
	print(velocity_target)


func x_bounds() -> Array[float]:
	var x: Array[float] = []

	for child in get_children():
		var center = child.global_position
		const car_length := 10.0 # TODO get from car dimensions
		x.append(center.x - car_length / 2.0)
		x.append(center.x + car_length / 2.0)

	return [x.min(), x.max()]
