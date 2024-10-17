@tool
extends Path3D
class_name UtilityPath


@export var spacing := 10.0
var num_poles := 0.0

var UtilityPole:ArrayMesh = preload("res://models/utility_pole/utility_pole.res")
var connections = [
	Vector3(-7.7171, 37.116, 0.0),
	Vector3(-1.8406, 37.116, 0.0),
	Vector3(7.6694, 37.116, 0.0),
	Vector3(0.0, 39.269, 0.0),
]

var multimesh_instance = MultiMeshInstance3D.new()
var multimesh = MultiMesh.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multimesh.mesh = UtilityPole
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh_instance.multimesh = multimesh

	print(UtilityPole.get_surface_count())

	var length := curve.get_baked_length()
	num_poles = length / spacing
	multimesh.instance_count = num_poles

	for i in range(num_poles):
		var pole_transform := curve.sample_baked_with_rotation(i * spacing)
		multimesh.set_instance_transform(i, pole_transform)

	add_child(multimesh_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
