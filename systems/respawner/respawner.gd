extends Marker3D


func respawn(target):
	target.global_position = global_position
	target.global_rotation = global_rotation
	target.get_node("Chargable").charge = 100.0
