extends Node


@export var accel := Vector3.ZERO
@export var vel := Vector3.ZERO
@export var pos := Vector3.ZERO


func _physics_process(delta):
	vel += accel * delta
	pos += vel * delta