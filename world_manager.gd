extends Node


var Station = preload("res://models/station/station.tscn")
@onready var world = get_tree().get_root().get_node("World")


var stations = []


func _ready():
	add_station()


func _physics_process(_delta):
	if Input.is_action_just_pressed("spawn_station"):
		print("Spawned station")
		add_station()


func add_station():
	var new_station = {
		"name": Namer.generate_station_name(),
		"spawned": false,
	}

	stations.append(new_station)


func instantiate_next_station() -> Node3D:
	var unspawned = WorldManager.stations.filter(func (s): return not s.spawned)
	
	if len(unspawned) == 0:
		return null

	var station = Station.instantiate()
	station.station_name = unspawned[0].name
	unspawned[0].spawned = true
	return station