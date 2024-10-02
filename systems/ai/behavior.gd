extends Node3D
class_name Behavior


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("behavior")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
