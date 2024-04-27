extends Area3D

signal control_link_changed(strength: float)

enum LinkState {
	BROKEN,
	WARN,
	SAFE,
}

var link := LinkState.BROKEN
var strength := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(_delta):
	var new_link: LinkState = LinkState.BROKEN

	var areas := get_overlapping_areas()
	for area in areas:
		if area.name == "SafeArea":
			new_link = LinkState.SAFE
			break
		elif area.name == "WarnArea":
			new_link = LinkState.WARN

	print(new_link)

	# If we are in the warn state we only overlap warns, and
	# need to determine the closest safe area.
	var space := get_world_3d().direct_space_state

	if new_link == LinkState.WARN:
		var results = []

		for warn_area in areas:
			var safe_area = warn_area.get_parent().get_node("SafeArea")

			var query = PhysicsRayQueryParameters3D.create(
				global_position, safe_area.global_position,
				4
			)
			query.collide_with_areas = true

			var result = space.intersect_ray(query)
			
			if not result:
				continue

			var distance_to_safe = result["position"].distance_to(global_position)
			var outwards_ray = (safe_area.global_position - global_position).normalized()
			print(outwards_ray)
			query = PhysicsRayQueryParameters3D.create(
				global_position, global_position + outwards_ray * 100,
				8
			)
			query.collide_with_areas = true
			query.hit_from_inside = true
			
			result = space.intersect_ray(query)
			
			if not result:
				continue
			
			print(result)
			var distance_to_warn = result["position"].distance_to(global_position)
			print(distance_to_safe, "   ", distance_to_warn)