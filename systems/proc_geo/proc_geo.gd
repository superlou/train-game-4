extends Node
class_name ProcGeo


static func bridge_edge_loops(start_loop, end_loop) -> Array:
	var num_points = len(start_loop)
	var vertices := []

	for i in range(num_points):
		var i0 := i
		var i1:int = (i + 1) % num_points

		vertices += [
			start_loop[i0], start_loop[i1], end_loop[i0],
			start_loop[i1], end_loop[i1], end_loop[i0],
		]

	return vertices


static func extrude_along_curve(loop:Array, curve:Curve3D, fractions:Array[float]) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var curve_length := curve.get_baked_length()

	for f in range(1, len(fractions)):
		var start_length = curve_length * fractions[f - 1]
		var end_length = curve_length * fractions[f]

		var start_loop = loop.map(func (p):
			return curve.sample_baked_with_rotation(start_length) * p
		)
		var end_loop = loop.map(func (p):
			return curve.sample_baked_with_rotation(end_length) * p
		)

		var vertices = ProcGeo.bridge_edge_loops(start_loop, end_loop)	
		st.add_triangle_fan(PackedVector3Array(vertices))

	return st.commit()