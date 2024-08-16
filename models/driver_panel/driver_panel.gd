extends Node3D


@export var velocity := 0.0
@export var torque := 0.0

const VELOCITY_GAUGE_ANGLE := [deg_to_rad(128.0), deg_to_rad(-131.0)]
const VELOCITY_GAUGE_VALUE := [0.0, 100.0]

const TORQUE_GAUGE_ANGLE := [deg_to_rad(128.0), deg_to_rad(-131.0)]
const TORQUE_GAUGE_VALUE := [0.0, 50_000.0]

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