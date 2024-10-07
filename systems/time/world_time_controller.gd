@tool
extends Node
class_name EnvironmentController


@export_range(0.0, 24.0) var clock := 12.0 :
	get:
		return clock
	set(value):
		clock = value
		_update_environment()

@export var animation_player:AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.speed_scale = 0.0
	animation_player.play("Environment")
	_update_environment()


func _update_environment():
	print(animation_player)
	if animation_player == null:
		return

	animation_player.seek(clock)
