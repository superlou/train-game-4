extends Node
class_name PIDController3

@export var kp := Vector3.ONE
@export var ki := Vector3.ZERO
@export var kd := Vector3.ZERO
@export var scale := Vector3.ONE

var accumulator := Vector3.ZERO
var prev_error := Vector3.ZERO


func set_k(kp_:Vector3, ki_:Vector3, kd_:Vector3):
    kp = kp_
    ki = ki_
    kd = kd_


func set_k_all(kp_:float, ki_:float, kd_:float):
    set_k(kp_ * Vector3.ONE, ki_ * Vector3.ONE, kd_ * Vector3.ONE)


func set_scale(scale_:Vector3):
    scale = scale_


func set_scale_all(scale_:float):
    set_scale(scale_ * Vector3.ONE)


func reset():
    accumulator = Vector3.ZERO
    prev_error = Vector3.ZERO


func run(process:Vector3, setpoint:Vector3, delta:float) -> Vector3:
    var error := setpoint - process

    if process.x > (0.9 * setpoint.x) and process.x < (1.1 * setpoint.x):
        accumulator.x += error.x
    else:
        accumulator.x = 0

    if process.y > (0.9 * setpoint.y) and process.y < (1.1 * setpoint.y):
        accumulator.y += error.y
    else:
        accumulator.y = 0

    if process.z > (0.9 * setpoint.z) and process.z < (1.1 * setpoint.z):
        accumulator.z += error.z
    else:
        accumulator.z = 0

    var derivative := (error - prev_error) / delta
    prev_error = error

    return scale * (kp * error + ki * accumulator + kd * derivative)