class_name Trainset
extends Node3D

@export var head_velocity := 0.0
@export var acceleration := 5.0
@export var breaking := 15.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_pressed("accelerate_right"):
		head_velocity += acceleration * delta
	
	if Input.is_action_pressed("accelerate_left"):
		head_velocity -= acceleration * delta

	if Input.is_action_pressed("apply_break"):
		if head_velocity > 0:
			if head_velocity - breaking * delta <= 0:
				head_velocity = 0
			else:
				head_velocity -= breaking * delta
		if head_velocity < 0:
			if head_velocity + breaking * delta >= 0:
				head_velocity = 0
			else:
				head_velocity += breaking * delta

func x_bounds() -> Array[float]:
	var x: Array[float] = [0.0]

	for child in get_children():
		var center = child.global_position
		const car_length := 10.0 # TODO get from car dimensions
		x.append(center.x - car_length / 2.0)
		x.append(center.x + car_length / 2.0)

	return [x.min(), x.max()]
