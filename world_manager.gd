extends Node


var Station = preload("res://models/station/station.tscn")
@onready var world = get_tree().get_root().get_node("World")

func _ready():
	pass


func _physics_process(_delta):
	if Input.is_action_just_pressed("spawn_station"):
		print("Spawned station")
		var trainset = world.get_node("Trainset")

		var station = Station.instantiate()
		station.position.x = 500.0
		station.trainset = trainset
		world.add_child(station) # Probably should track these
