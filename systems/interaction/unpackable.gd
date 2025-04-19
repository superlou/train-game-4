extends Node
class_name Unpackable


@export var animation_player:AnimationPlayer
@export var unpack_animation:String
@export var invert_unpack_animation := false
@export_range(0.0, 1.0) var unpack_fraction:float = 0.0


var _unpack_duration:float

signal finished_packing
signal finished_unpacking


enum PackState {
	UNPACKED,
	PACKED
}

var last_pack_state := PackState.PACKED


func _ready() -> void:
	_unpack_duration = animation_player.get_animation(unpack_animation).length
	animation_player.play(unpack_animation, -1.0, 0.0)
	animation_player.seek(target_time())

	if unpack_fraction == 0.0:
		finished_packing.emit()
		last_pack_state = PackState.PACKED
	elif unpack_fraction == 1.0:
		finished_unpacking.emit()
		last_pack_state = PackState.UNPACKED


func target_time() -> float:
	var time:float = 0.0

	if invert_unpack_animation:
		time = (1 - unpack_fraction) * _unpack_duration
	else:
		time = unpack_fraction * _unpack_duration
	
	# Need a small offset to prevent animation from reach the very end
	return maxf(time - 0.001, 0.0)


func is_packed() -> bool:
	return unpack_fraction == 0.0


func is_unpacked() -> bool:
	return unpack_fraction == 1.0


func pack(delta:float):
	var was_packed := is_packed()
	unpack_fraction = clampf(unpack_fraction - delta / _unpack_duration, 0.0, 1.0)
	animation_player.seek(target_time())

	if not was_packed and is_packed():
		finished_packing.emit()
		last_pack_state = PackState.PACKED


func unpack(delta:float):
	var was_unpacked := is_unpacked()
	unpack_fraction = clampf(unpack_fraction + delta / _unpack_duration, 0.0, 1.0)
	animation_player.seek(target_time())

	if not was_unpacked and is_unpacked():
		finished_unpacking.emit()
		last_pack_state = PackState.UNPACKED
