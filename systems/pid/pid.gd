extends Node
class_name PIDController

@export var kp := 1.0
@export var ki := 0.0
@export var kd := 0.0

var accumulator := 0.0
var last := 0.0


func run(process: float, setpoint: float, delta: float) -> float:
	var error := setpoint - process

	if process > (0.9 * setpoint) and process < (1.1 * setpoint):
		accumulator += error
	else:
		accumulator = 0
	
	var derivative := (process - last) / delta
	last = process

	return kp * error + ki * accumulator + kd * derivative