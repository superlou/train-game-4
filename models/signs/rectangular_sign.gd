@tool
extends Node3D

@export_group("Text")
@export var text := "EXAMPLE STATION" :
	set(value):
		text = value
		_update()

@export var text_color := Color.WHITE :
	set(value):
		text_color = value
		_update()

@export var pad := 0.1 :
	set(value):
		pad = value
		_update() 

@export_group("Border", "border_")
@export var border := 0.05 :
	set(value):
		border = value
		_update()

@export var border_color := Color.BLACK :
	set(value):
		border_color = value
		_update()

@export var border_depth := 0.05 :
	set(value):
		border_depth = value
		_update()

@export_group("Backing", "backing_")
@export var backing_thickness := 0.05 :
	set(value):
		backing_thickness = value
		_update()

@export var backing_color := Color.GRAY :
	set(value):
		backing_color = value
		_update()

enum SupportType {
	NONE,
	POLES,
	CHAINS,
}

@export_group("Supports", "support_")
@export var support_type := SupportType.NONE :
	set(value):
		support_type = value
		_update()

@export var support_spacing := 0.8 :
	set(value):
		support_spacing = value
		_update()

@export var support_color := Color.SADDLE_BROWN :
	set(value):
		support_color = value
		_update()


@onready var label:Label3D = $Sign/Label
@onready var backing_mesh:MeshInstance3D = $Sign/BackingMesh
@onready var frame_mesh:MeshInstance3D = $Sign/FrameMesh


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update()


func _update():
	var backing_material = StandardMaterial3D.new()
	backing_material.albedo_color = backing_color

	var frame_material = StandardMaterial3D.new()
	frame_material.albedo_color = border_color

	label.text = text
	# todo This doesn't always work. Sometimes the AABB isn't updated.
	# Waiting until the next frame also isn't enough.
	var label_aabb := label.get_aabb()

	label.modulate = text_color
	backing_mesh.mesh = _build_backing(label_aabb, backing_material, frame_material)
	frame_mesh.mesh = _build_frame(label_aabb, frame_material)

	var pole_height = 1.5
	var pole_width = 0.15

	if support_type == SupportType.POLES:
		var pole_xs := _calc_pole_xs(backing_mesh.get_aabb().size.x)
		_build_poles(pole_xs, pole_height, pole_width)
		$Sign.position = Vector3(
			0.0,
			pole_height - backing_mesh.get_aabb().size.y / 2.0,
			backing_thickness + pole_width / 2.0
		)
	else:
		_clear_poles()
		backing_mesh.position = Vector3.ZERO
		frame_mesh.position = Vector3.ZERO
		$Sign.position = Vector3.ZERO


func _calc_pole_xs(width:float) -> Array:
	var num_poles := int(width / support_spacing) + 1

	var xs = range(num_poles).map(func(i): return i * support_spacing)

	if num_poles % 2 == 0:
		return xs.map(func(x): return x - support_spacing * (floorf(num_poles / 2.0) - 0.5))
	else:
		return xs.map(func(x): return x - support_spacing * floorf(num_poles / 2.0))


func _clear_poles():
	for child in $Poles.get_children():
		child.queue_free()


func _build_poles(xs:Array, height:float, width:float) -> void:
	_clear_poles()

	var pole_material := StandardMaterial3D.new()
	pole_material.albedo_color = support_color

	for x in xs:
		var pole := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = Vector3(width, height, width)
		mesh.material = pole_material
		pole.mesh = mesh
		pole.position = Vector3(x, height / 2.0, 0.0)
		$Poles.add_child(pole)

		var pole_base := MeshInstance3D.new()
		var base_mesh := BoxMesh.new()
		var base_width := width + 0.1
		var base_height := 0.05
		pole_base.mesh = base_mesh
		base_mesh.size = Vector3(base_width, base_height, base_width)
		base_mesh.material = pole_material
		pole_base.position = Vector3(x, base_height / 2.0, 0) 
		$Poles.add_child(pole_base)


func _build_backing(
		aabb:AABB, backing_material:Material, frame_material:Material
	) -> ArrayMesh:
	var pos := aabb.position
	var size := aabb.size

	var p0 := pos + Vector3(-pad - border, -pad - border, 0)
	var p1 := pos + Vector3(-pad - border, size.y + pad + border, 0)
	var p2 := pos + Vector3(size.x + pad + border, size.y + pad + border, 0)
	var p3 := pos + Vector3(size.x + pad + border, -pad - border, 0)

	var p4 := p0 + Vector3(0, 0, -backing_thickness)
	var p5 := p1 + Vector3(0, 0, -backing_thickness)
	var p6 := p2 + Vector3(0, 0, -backing_thickness)
	var p7 := p3 + Vector3(0, 0, -backing_thickness)

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)

	st.set_material(backing_material)
	st.add_triangle_fan(PackedVector3Array([p0, p1, p2, p3])) # Front
	var front_surface = st.commit()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	st.set_material(frame_material)
	st.add_triangle_fan(PackedVector3Array([p7, p6, p5, p4])) # Back
	st.add_triangle_fan(PackedVector3Array([p2, p6, p7, p3])) # Right
	st.add_triangle_fan(PackedVector3Array([p0, p4, p5, p1])) # Left
	st.add_triangle_fan(PackedVector3Array([p1, p5, p6, p2])) # Top
	st.add_triangle_fan(PackedVector3Array([p0, p3, p7, p4])) # Bottom

	st.generate_normals()
	return st.commit(front_surface)


func _build_frame(aabb:AABB, frame_material:Material) -> ArrayMesh:
	var pos := aabb.position
	var size := aabb.size

	var p0 := pos + Vector3(-pad - border, -pad - border, border_depth)
	var p1 := pos + Vector3(-pad - border, size.y + pad + border, border_depth)
	var p2 := pos + Vector3(size.x + pad + border, size.y + pad + border, border_depth)
	var p3 := pos + Vector3(size.x + pad + border, -pad - border, border_depth)

	var p4 := p0 + Vector3(0, 0, -border_depth)
	var p5 := p1 + Vector3(0, 0, -border_depth)
	var p6 := p2 + Vector3(0, 0, -border_depth)
	var p7 := p3 + Vector3(0, 0, -border_depth)

	var p8 := pos + Vector3(-pad, -pad, border_depth)
	var p9 := pos + Vector3(-pad, size.y + pad, border_depth)
	var p10 := pos + Vector3(size.x + pad, size.y + pad, border_depth)
	var p11 := pos + Vector3(size.x + pad, -pad, border_depth)

	var p12 := p8 + Vector3(0, 0, -border_depth)
	var p13 := p9 + Vector3(0, 0, -border_depth)
	var p14 := p10 + Vector3(0, 0, -border_depth)
	var p15 := p11 + Vector3(0, 0, -border_depth)

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	st.set_material(frame_material)

	st.add_triangle_fan(PackedVector3Array([p2, p6, p7, p3])) # Right
	st.add_triangle_fan(PackedVector3Array([p0, p4, p5, p1])) # Left
	st.add_triangle_fan(PackedVector3Array([p1, p5, p6, p2])) # Top
	st.add_triangle_fan(PackedVector3Array([p0, p3, p7, p4])) # Bottom

	st.add_triangle_fan(PackedVector3Array([p10, p11, p15, p14])) # Right Inside
	st.add_triangle_fan(PackedVector3Array([p8, p9, p13, p12])) # Left Inside
	st.add_triangle_fan(PackedVector3Array([p9, p10, p14, p13])) # Top Inside
	st.add_triangle_fan(PackedVector3Array([p8, p12, p15, p11])) # Bottom Inside

	# Front
	st.add_triangle_fan(PackedVector3Array([p0, p8, p11, p3]))
	st.add_triangle_fan(PackedVector3Array([p0, p1, p9, p8]))
	st.add_triangle_fan(PackedVector3Array([p1, p2, p10, p9]))
	st.add_triangle_fan(PackedVector3Array([p2, p3, p11, p10]))

	# Back
	st.add_triangle_fan(PackedVector3Array([p4, p7, p15, p12]))
	st.add_triangle_fan(PackedVector3Array([p6, p14, p15, p7]))
	st.add_triangle_fan(PackedVector3Array([p5, p13, p14, p6]))
	st.add_triangle_fan(PackedVector3Array([p4, p12, p13, p5]))

	st.generate_normals()
	return st.commit()