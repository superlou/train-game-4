extends Node3D


@export var velocity := 0.0
@export var torque := 0.0

const VELOCITY_GAUGE_ANGLE := [deg_to_rad(128.0), deg_to_rad(-131.0)]
const VELOCITY_GAUGE_VALUE := [0.0, 100.0]

const TORQUE_GAUGE_ANGLE := [deg_to_rad(128.0), deg_to_rad(-131.0)]
const TORQUE_GAUGE_VALUE := [0.0, 50_000.0]

signal requested_velocity_change(amount:float)
signal requested_velocity_stop

signal requested_throttle_change(amount:float)
signal requested_throttle_stop


@export var control_mode := Trainset.ControlMode.THROTTLE


func _ready():
	pass # Replace with function body.


func _process(_delta):
	var speed := absf(velocity)
	var torque_mag := absf(torque)

	%VelocityBone.rotation.y = remap(
		speed,
	    VELOCITY_GAUGE_VALUE[0], VELOCITY_GAUGE_VALUE[1],
		VELOCITY_GAUGE_ANGLE[0], VELOCITY_GAUGE_ANGLE[1]
	)

	%TorqueBone.rotation.y = remap(
		torque_mag,
	    TORQUE_GAUGE_VALUE[0], TORQUE_GAUGE_VALUE[1],
		TORQUE_GAUGE_ANGLE[0], TORQUE_GAUGE_ANGLE[1]
	)

	match control_mode:
		Trainset.ControlMode.THROTTLE:
			$ThrottleControlLamp.active = true
			$SpeedControlLamp.active = false
		Trainset.ControlMode.VELOCITY:
			$ThrottleControlLamp.active = false
			$SpeedControlLamp.active = true
	
	$ThrottleReverseLamp.active = torque < 0
	$SpeedReverseLamp.active = velocity < 0



func _on_speed_inc_button_pressed():
	requested_velocity_change.emit(5)


func _on_speed_stop_button_pressed():
	requested_velocity_stop.emit()


func _on_speed_dec_button_pressed():
	requested_velocity_change.emit(-5)


func _on_throttle_inc_button_pressed():
	requested_throttle_change.emit(0.1)


func _on_throttle_stop_button_pressed():
	requested_throttle_stop.emit()


func _on_throttle_dec_button_pressed():
	requested_throttle_change.emit(-0.1)
