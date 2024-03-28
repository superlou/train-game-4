extends Node3D


var ground_velocity = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for child in get_children():
		child.position.x -= ground_velocity


func _on_trainset_changed_velocity(amount:float):
	ground_velocity = amount
