class_name Trainset
extends Node3D

@export var head_velocity := Vector3.ZERO
@export var acceleration := 5.0
@export var breaking := 15.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Physics priority needs to be set lower than other nodes otherwise
# velocity between the train and other objects won't be quite right
# when accelerating.
func _physics_process(delta):
	var head_accel := Vector3.ZERO

	if Input.is_action_pressed("accelerate_right"):
		head_accel += Vector3.RIGHT * acceleration
	
	if Input.is_action_pressed("accelerate_left"):
		head_accel += -Vector3.RIGHT * acceleration

	if Input.is_action_pressed("apply_break"):
		if head_velocity.length() <= breaking * delta:
				head_accel = -head_velocity / delta
		elif head_velocity.x > 0:
			head_accel += -Vector3.RIGHT * breaking
		elif head_velocity.x < 0:
			head_accel += Vector3.RIGHT * breaking

	RelativeWorld.accel = -head_accel
	head_velocity += head_accel * delta


func x_bounds() -> Array[float]:
	var x: Array[float] = []

	for child in get_children():
		var center = child.global_position
		const car_length := 10.0 # TODO get from car dimensions
		x.append(center.x - car_length / 2.0)
		x.append(center.x + car_length / 2.0)

	return [x.min(), x.max()]
