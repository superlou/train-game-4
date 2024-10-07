@tool
extends AnimationPlayer
class_name EnvironmentAnimation


@export_range(0.0, 24.0) var clock := 12.0 :
	get:
		return clock
	set(value):
		clock = value
		_update_environment()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed_scale = 0.0
	play("Environment")
	_update_environment()


func _update_environment():
	seek(clock)
