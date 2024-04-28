extends Area3D

signal control_link_changed(strength: float)

enum LinkState {
	BROKEN,
	WARN,
	SAFE,
}

var link := LinkState.BROKEN
var strength := 1.0
var first_run := true

# Called when the node enters the scene tree for the first time.
func _ready():
	control_link_changed.emit(1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	if first_run:
		# Area3Ds don't seem ready on first physics process
		first_run = false
		return

	var new_link: LinkState = LinkState.BROKEN

	var areas := get_overlapping_areas()
	for area in areas:
		if area.name == "SafeArea":
			new_link = LinkState.SAFE
			break
		elif area.name == "WarnArea":
			new_link = LinkState.WARN

	var new_strength: float

	match new_link:
		LinkState.SAFE:
			new_strength = 1.0
		LinkState.WARN:
			new_strength = 0.5
		LinkState.BROKEN:
			new_strength = 0.0

	if new_strength != strength:
		control_link_changed.emit(new_strength)
	
	link = new_link
	strength = new_strength

	# Using distance didn't work out.
	# # If we are in the warn state we only overlap warns, and
	# # need to determine the closest safe area.
	# var space := get_world_3d().direct_space_state

	# if new_link == LinkState.WARN:
	# 	var results = []

	# 	for warn_area in areas:
	# 		var safe_area = warn_area.get_parent().get_node("SafeArea")

	# 		var query = PhysicsRayQueryParameters3D.create(
	# 			global_position, safe_area.global_position,
	# 			4
	# 		)
	# 		query.collide_with_areas = true

	# 		var result = space.intersect_ray(query)
			
	# 		if not result:
	# 			continue

	# 		var distance_to_safe = result["position"].distance_to(global_position)
	# 		var outwards_ray = (safe_area.global_position - global_position).normalized()
	# 		print(outwards_ray)
	# 		query = PhysicsRayQueryParameters3D.create(
	# 			global_position, global_position + outwards_ray * 100,
	# 			8
	# 		)
	# 		query.collide_with_areas = true
	# 		query.hit_from_inside = true
			
	# 		result = space.intersect_ray(query)
			
	# 		if not result:
	# 			continue
			
	# 		print(result)
	# 		var distance_to_warn = result["position"].distance_to(global_position)
	# 		print(distance_to_safe, "   ", distance_to_warn)