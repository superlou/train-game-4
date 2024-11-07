@tool
extends Path3D
class_name UtilityPath


@export var num_poles := 5
@export var max_overlap_distance := 1.0

var UtilityPole:ArrayMesh = preload("res://models/utility_pole/utility_pole.res")
var pole_roots = [
	Vector3(-2.3502, 11.366, 0.3033),
	Vector3(-0.559, 11.366, 0.3033),
	Vector3(2.340, 11.366, 0.3033),
	Vector3(0.0, 11.986, 0.0),
]

const WIRE_DIAMETER = 0.08
var wire_profile:Array = [
	Vector3(WIRE_DIAMETER, 0, 0),
	Vector3(0, WIRE_DIAMETER, 0),
	Vector3(-WIRE_DIAMETER, 0, 0),
	Vector3(0, -WIRE_DIAMETER, 0),
]

var multimesh_instance = MultiMeshInstance3D.new()
var multimesh = MultiMesh.new()
var wire_material = StandardMaterial3D.new()
var pole_connections:Array[int] = []
var wires = []	# Each index holds the wires from the current pole to the next.
				# There is one less index than the number of poles.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wire_material.albedo_color = Color.BLACK

	# Multimesh remains at the local origin
	multimesh.mesh = UtilityPole
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh_instance.multimesh = multimesh

	var length := curve.get_baked_length()
	var spacing = length / (num_poles - 1)
	multimesh.instance_count = num_poles

	for i in range(num_poles):
		var pole_transform := curve.sample_baked_with_rotation(i * spacing)
		multimesh.set_instance_transform(i, pole_transform)
		pole_connections.append(0)

	add_child(multimesh_instance)
	add_internal_lines()


func add_internal_lines():
	for i in range(num_poles - 1):
		var start_pole := i
		var end_pole := i + 1
		var start_pole_transform := get_pole_transform(start_pole)
		var end_pole_transform := get_pole_transform(end_pole)
		var wire_mesh_instances := add_lines_between_poles(start_pole_transform, end_pole_transform)
		wires.append(wire_mesh_instances)
		pole_connections[start_pole] += 1
		pole_connections[end_pole] += 1


func get_pole_transform(pole_id:int) -> Transform3D:
	if pole_id < 0:
		pole_id += num_poles
	return multimesh.get_instance_transform(pole_id)


func get_pole_global_transform(pole_id:int) -> Transform3D:
	if pole_id < 0:
		pole_id += num_poles
	return global_transform * multimesh.get_instance_transform(pole_id)


func find_terminal_pole_overlaps(other_path:UtilityPath) -> Array[int]:
	"""	Returns the pole ids that overlap, with the first in self, and the second in other.
	Returns an empty array if there are no overlapping poles.
	"""
	var self_first_pos := get_pole_global_transform(0).origin
	var self_last_pos := get_pole_global_transform(-1).origin
	var other_first_pos := other_path.get_pole_global_transform(0).origin
	var other_last_pos := other_path.get_pole_global_transform(-1).origin

	if self_first_pos.distance_to(other_first_pos) < max_overlap_distance:
		return [0, 0]
	elif self_first_pos.distance_to(other_last_pos) < max_overlap_distance:
		return [0, -1]
	elif self_last_pos.distance_to(other_first_pos) < max_overlap_distance:
		return[-1, 0]
	elif self_last_pos.distance_to(other_last_pos) < max_overlap_distance:
		return [-1, -1]
	else:
		return []


func bridge(self_pole:int, _other_path:UtilityPath, _other_pole:int):
	"""
	It's the responsibility of the ground tile
	to draw UtilityPath curves so that you can simply hide the overlapping
	pole.

	If this was a city builder, it might be better to do something like the
	following steps:
 
		1. Hide common pole from self
		2. Remove wires to the hidden pole
		3. Rotate common pole from other to average self and other's pole
		4. Re-add wires
	"""
	hide_pole(self_pole)

	# if self_pole == 0:
	# 	for instance in wires[0]:
	# 		remove_child(instance)
	# 		instance.queue_free()
	# elif self_pole == num_poles - 1:
	# 	for instance in wires[-1]:
	# 		remove_child(instance)
	# 		instance.queue_free()


func hide_pole(pole_id:int):
	if pole_id < 0:
		pole_id += num_poles
	var ZERO_TRANSFORM = Transform3D.IDENTITY.scaled(Vector3.ZERO)
	multimesh.set_instance_transform(pole_id, ZERO_TRANSFORM)
			

func add_lines_between_poles(transform0, transform1) -> Array[MeshInstance3D]:
	var wire_mesh_instances = []

	for root in pole_roots:
		var wire_curve := Curve3D.new()
		var start: Vector3 = transform0 * root
		var end: Vector3 = transform1 * root
		var mid = (start + end) / 2
		var mid0 = (start + mid) / 2
		var mid1 = (end + mid) / 2
		mid.y -= 1
		mid0.y -= 0.75
		mid1.y -= 0.75
		wire_curve.add_point(start)
		wire_curve.add_point(mid0)
		wire_curve.add_point(mid)
		wire_curve.add_point(mid1)
		wire_curve.add_point(end)
		
		var wire := MeshInstance3D.new()
		wire.mesh = ProcGeo.extrude_along_curve(
			wire_profile,
			wire_curve,
			[0.0, 0.25, 0.5, 0.75, 1.0]
		)
		wire.mesh.surface_set_material(0, wire_material)
		add_child(wire)
		wire_mesh_instances.append(wire)
	
	var wire_mesh_instances_typed:Array[MeshInstance3D] = []
	wire_mesh_instances_typed.assign(wire_mesh_instances)
	return wire_mesh_instances_typed
