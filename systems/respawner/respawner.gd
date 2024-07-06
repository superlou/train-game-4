extends Marker3D


func respawn(target):
	target.global_position = global_position
	target.global_rotation = global_rotation
