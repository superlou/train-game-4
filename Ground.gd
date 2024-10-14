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
	var leftmost_tile = get_child(0)
	var rightmost_tile = get_child(-1)

	# Add more tiles behind
	while leftmost_tile.position.x > (train_min_x - LOOK_BEHIND):
		var tile = GroundTile.instantiate()
		tile.position.x = leftmost_tile.position.x - leftmost_tile.width
		add_child(tile)
		move_child(tile, 0)
		leftmost_tile = tile

	# Add more tiles ahead
	while rightmost_tile.position.x < (train_max_x + LOOK_AHEAD):
		var tile = GroundTile.instantiate()
		tile.position.x = rightmost_tile.position.x + rightmost_tile.width
		tile.station = WorldManager.instantiate_next_station()
		add_child(tile)
		rightmost_tile = tile

	# Remove old tiles behind
	# Don't remove "old" tiles ahead so that players can't regenerate tiles
	# that already existed.
	if leftmost_tile.position.x < (train_min_x - LOOK_BEHIND):
		remove_child(leftmost_tile)
		leftmost_tile.queue_free()
