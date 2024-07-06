extends Area3D
class_name RssiArea

@export var zero_radius := 0.0
@export var disabled := false
@onready var collision_shape : CollisionShape3D = get_child(0)


func get_distance(pos: Vector3) -> float:
	# todo Logic if sphere
	if collision_shape.shape is CapsuleShape3D:
		var shape:CapsuleShape3D = collision_shape.shape

		# Capsules are normally vertical, but could be rotated by a
		# transformation.
		var focus := shape.height / 2 - shape.radius
		var s1 = collision_shape.global_transform * Vector3(0, focus, 0)
		var s2 = collision_shape.global_transform * Vector3(0, -focus, 0)

		var closest := Geometry3D.get_closest_point_to_segment(
			pos, s1, s2
		)

		return pos.distance_to(closest)

	return 0.0


func get_distance_bounds_normalized(pos: Vector3) -> float:
	var distance := get_distance(pos)
	var normalizer := 1.0

	distance = maxf(distance - zero_radius, 0.)

	if collision_shape.shape is CapsuleShape3D:
		normalizer = collision_shape.shape.radius
	elif collision_shape.shape is SphereShape3D:
		normalizer = collision_shape.shape.radius
	
	normalizer = maxf(normalizer - zero_radius, 0.)

	return distance / normalizer