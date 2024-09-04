extends Node


var Station = preload("res://models/station/station.tscn")
@onready var world = get_tree().get_root().get_node("World")

func _ready():
	pass


func _physics_process(_delta):
	if Input.is_action_just_pressed("spawn_station"):
		print("Spawned station")
		var station = Station.instantiate()
		station.station_name = Namer.generate_station_name()
		world.get_node("Ground").request_station = station
