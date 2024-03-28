extends Node3D

@export var head_velocity := 0.0
@export var acceleration := 0.1
signal changed_velocity(amount: float)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_pressed("accelerate_right"):
		head_velocity += acceleration * delta
		changed_velocity.emit(head_velocity)
	
	if Input.is_action_pressed("accelerate_left"):
		head_velocity -= acceleration * delta
		changed_velocity.emit(head_velocity)
	
