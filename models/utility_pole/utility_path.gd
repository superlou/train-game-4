@tool
extends Path3D
class_name UtilityPath


@export var num_poles := 5
@export var max_connect_distance := 10

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wire_material.albedo_color = Color.BLACK

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
	print(pole_connections)


func add_internal_lines():
	for i in range(1, num_poles):
		var start_pole := i - 1
		var end_pole := i
		var start_pole_transform := get_pole_transform(start_pole)
		var end_pole_transform := get_pole_transform(end_pole)
		add_lines_between_poles(start_pole_transform, end_pole_transform)
		pole_connections[start_pole] += 1
		pole_connections[end_pole] += 1


func get_pole_transform(pole_id:int) -> Transform3D:
	return multimesh.get_instance_transform(pole_id)


func bridge_paths(utility_paths:Array[UtilityPath]):
	if len(utility_paths) == 0:
		return

	for self_pole_id in range(len(pole_connections)):
		if pole_connections[self_pole_id] < 2:
			var self_pole_transform := get_pole_transform(self_pole_id)

			var closest_utility_path:UtilityPath = null
			var closest_pole_id := -1
			var closest_distance_squared := INF

			for other_utility_path in utility_paths:
				for other_pole_id in range(other_utility_path.num_poles):
					print(other_pole_id)
					var other_pole_transform := other_utility_path.get_pole_transform(other_pole_id)
					var distance := self_pole_transform.origin.distance_squared_to(other_pole_transform.origin)
					if distance < closest_distance_squared:
						closest_distance_squared = distance
						closest_utility_path = other_utility_path
						closest_pole_id = other_pole_id
			


func add_lines_between_poles(transform0, transform1):
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
