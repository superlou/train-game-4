extends Area3D

@export var chargable:Chargable 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var areas := get_overlapping_areas()

	if len(areas) > 0:
		chargable.modify_charge(20.0 * delta)
