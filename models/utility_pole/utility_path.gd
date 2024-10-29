@tool
extends Path3D
class_name UtilityPath


@export var num_poles := 5

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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multimesh.mesh = UtilityPole
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh_instance.multimesh = multimesh

	var length := curve.get_baked_length()
	var spacing = length / (num_poles - 1)
	multimesh.instance_count = num_poles

	for i in range(num_poles):
		var pole_transform := curve.sample_baked_with_rotation(i * spacing)
		multimesh.set_instance_transform(i, pole_transform)

	add_child(multimesh_instance)
	string_lines()


func string_lines():
	var wire_material = StandardMaterial3D.new()
	wire_material.albedo_color = Color.BLACK
	
	for i in range(1, num_poles):	
		var start_pole_transform := multimesh.get_instance_transform(i - 1)
		var end_pole_transform := multimesh.get_instance_transform(i)

		for root in pole_roots:
			var wire_curve := Curve3D.new()
			var start: Vector3 = start_pole_transform * root
			var end: Vector3 = end_pole_transform * root
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
