extends Node3D


var ground_velocity = 0
@export var trainset: Trainset

var GroundTile = preload("res://ground_tile.tscn")
const LOOK_AHEAD := 500.0
const LOOK_BEHIND := 500.0
var request_station = null

func _ready():
	plant_tiles()


func _physics_process(delta):
	plant_tiles() # must happen before moving otherwise gaps form

	for child in get_children():
		child.position += RelativeWorld.vel * delta


func plant_tiles():
	var train_bounds := trainset.x_bounds()
	var train_min_x := train_bounds[0]
	var train_max_x := train_bounds[1]

	# Add first tile
	if len(get_children()) == 0:
		var tile = GroundTile.instantiate()
		tile.position = Vector3.ZERO
		tile.station = WorldManager.instantiate_next_station()
		add_child(tile)
	
	# Make sure the first child is the leftmost (-x) and the
	# last child is the rightmost (+x).
	var rear_tile = get_child(0)
	var lead_tile = get_child(-1)

	# Add more tiles behind
	while rear_tile.position.x > (train_min_x - LOOK_BEHIND):
		var new_tile := GroundTile.instantiate()
		new_tile.position.x = rear_tile.position.x - rear_tile.width
		new_tile.next_tile = rear_tile
		rear_tile.prev_tile = new_tile
		add_child(new_tile)
		move_child(new_tile, 0)
		new_tile.link_geometry()
		rear_tile = new_tile

	# Add more tiles ahead
	while lead_tile.position.x < (train_max_x + LOOK_AHEAD):
		var new_tile := GroundTile.instantiate()
		new_tile.position.x = lead_tile.position.x + lead_tile.width
		new_tile.prev_tile = lead_tile
		lead_tile.next_tile = new_tile
		new_tile.station = WorldManager.instantiate_next_station()
		add_child(new_tile)
		new_tile.link_geometry()
		lead_tile = new_tile

	# Remove old tiles behind
	# Don't remove "old" tiles ahead so that players can't regenerate tiles
	# that already existed.
	if rear_tile.position.x < (train_min_x - LOOK_BEHIND - rear_tile.width):
		remove_child(rear_tile)
		rear_tile.queue_free()
		var new_rear_tile := get_child(0)
		new_rear_tile.prev_tile = null
