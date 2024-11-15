extends Node3D
class_name Behavior

@export var offer:UtilityAIOffer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("behavior")


func advertises() -> UtilityAIOffer:
	# Each subclass should specify what it advertises.
	# Override if this behavior's offers depend on other logic.
	# Return null if this behavior can't be executed.
	print("Not implemented!")
	return null