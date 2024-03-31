extends Node3D


var ground_velocity = 0
@export var trainset: Trainset

var tile_scene = preload("res://ground_tile.tscn")
const TILE_WIDTH := 20.0
const LOOK_AHEAD := 100.0
const LOOK_BEHIND := 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	plant_tiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	plant_tiles() # must happen before moving otherwise gaps form

	for child in get_children():
		child.position.x -= trainset.head_velocity * delta


func plant_tiles():
	var train_bounds := trainset.x_bounds()
	var train_min_x := train_bounds[0]
	var train_max_x := train_bounds[1]

	if len(get_children()) == 0:
		var tile = tile_scene.instantiate()
		tile.position = Vector3.ZERO
		add_child(tile)
	
	# Make sure the first child is the leftmost (-x) and the
	# last child is the rightmost (+x).
	var leftmost_tile = get_child(0)
	var rightmost_tile = get_child(-1)

	# Add more tiles ahead
	while leftmost_tile.position.x > (train_min_x - LOOK_BEHIND):
		var tile = tile_scene.instantiate()
		tile.position.x = leftmost_tile.position.x - TILE_WIDTH
		print(tile.position.x)
		add_child(tile)
		move_child(tile, 0)
		leftmost_tile = tile

	# Add more tiles behind
	while rightmost_tile.position.x < (train_max_x + LOOK_AHEAD):
		var tile = tile_scene.instantiate()
		tile.position.x = rightmost_tile.position.x + TILE_WIDTH
		add_child(tile)
		rightmost_tile = tile

	# Remove old tiles behind
	# Don't remove "old" tiles ahead so that players can't regenerate tiles
	# that already existed.
	if leftmost_tile.position.x < (train_min_x - LOOK_BEHIND):
		remove_child(leftmost_tile)
		leftmost_tile.queue_free()