@tool
extends AnimatableBody3D

@export var width := 50.0
@export var plank_separation := 1.0

var is_dirty := false
var station = null

# Called when the node enters the scene tree for the first time.
func _ready():
	is_dirty = true

	if station:
		add_child(station)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_dirty:
		update_track()
		is_dirty = false


func update_track():
	var curve: Curve3D = $TrackPath.curve
	var path_length: float = curve.get_baked_length()
	var count = floor(path_length / plank_separation)
	
	var mm: MultiMesh = $TrackPath/Ties.multimesh
	mm.instance_count = count

	var offset := plank_separation / 2.0

	for i in range(0, count):
		var curve_distance := offset + plank_separation * i
		var tie_position := curve.sample_baked(curve_distance, true)
		
		var tie_basis := Basis()
		var up := curve.sample_baked_up_vector(curve_distance, true)
		var forward := position.direction_to(curve.sample_baked(curve_distance + 0.1, true))
		tie_basis.x = forward.cross(up).normalized()
		tie_basis.y = up
		tie_basis.z = -forward

		var tie_transform := Transform3D(tie_basis, tie_position)
		mm.set_instance_transform(i, tie_transform)


func _on_track_path_curve_changed():
	is_dirty = true
