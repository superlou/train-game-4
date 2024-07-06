extends Area3D

@export var ignore_area:RssiArea


var strength := 1.0
signal strength_changed(val:float)

func _ready():
	strength_changed.emit(1.0)

func _process(_delta):
	var prev_strength := strength
	var normalized_distance := 1.0

	# Collision layer/masks should ensure all areas are RssiArea
	for area: RssiArea in get_overlapping_areas():
		if area == ignore_area or area.disabled:
			continue

		# print("Distance: ", area.get_distance(global_position))
		# print("Normalized: ", area.get_distance_bounds_normalized(global_position))
		var area_distance := area.get_distance_bounds_normalized(global_position)

		if area_distance < normalized_distance:
			normalized_distance = area_distance

	strength = clampf(1.0 - normalized_distance, 0.0, 1.0)
	
	if strength != prev_strength:
		strength_changed.emit(strength)