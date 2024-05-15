extends RigidBody3D
class_name ShiftRigidBody


var shift := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _integrate_forces(state: PhysicsDirectBodyState3D):
	if shift != 0.0:
		state.transform.origin.x += shift
		print(state.transform.origin)
		shift = 0.0