extends Node3D

signal raising
signal raised
signal lowering
signal lowered

var state: String = "lowered"  # todo Use global enum?

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("raised", func(): state = "raised")
	connect("lowered", func(): state = "lowered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func raise():
	if ["raised", "raising"].has(state):
		return

	$AnimationPlayer.play("raise")
	state = "raising"


func lower():
	if ["lowered", "lowering"].has(state):
		return
	
	$AnimationPlayer.play("lower")
	state = "lowering"

