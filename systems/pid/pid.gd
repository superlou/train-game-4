extends Node
class_name PIDController

@export var kp := 1.0
@export var ki := 0.0
@export var kd := 0.0
@export var scale := 1.0

var accumulator := 0.0
var prev_error := 0.0


func set_k(kp_: float, ki_: float, kd_: float):
	kp = kp_
	ki = ki_
	kd = kd_


func set_scale(scale_: float):
	scale = scale_


func run(process: float, setpoint: float, delta: float) -> float:
	var error := setpoint - process

	if process > (0.9 * setpoint) and process < (1.1 * setpoint):
		accumulator += error
	else:
		accumulator = 0
	
	var derivative := (error - prev_error) / delta
	prev_error = error	

	return scale * (kp * error + ki * accumulator + kd * derivative)


func reset():
	accumulator = 0.0
	prev_error = 0.0
