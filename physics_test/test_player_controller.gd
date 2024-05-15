extends Node
class_name TestPlayerController

@onready var player: RigidBody3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("move_forward"):
		player.apply_force(Vector3.FORWARD * 1000.0)
	elif Input.is_action_pressed("move_backward"):
		player.apply_force(Vector3.FORWARD * -1000.0)
