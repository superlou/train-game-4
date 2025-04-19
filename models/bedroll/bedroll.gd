extends RelativeBody


@onready var unpackable:Unpackable = $Unpackable
var _being_used := false


@onready var carryable := $Carryable


func _on_interactable_using(_interactor:Interactor) -> void:
	_being_used = true


var finished_cooloff = false


func _process(delta: float) -> void:
	if _being_used and not finished_cooloff:
		if unpackable.last_pack_state == Unpackable.PackState.UNPACKED:
			unpackable.pack(delta)
		else:
			unpackable.unpack(delta)
	else:
		if unpackable.last_pack_state == Unpackable.PackState.UNPACKED and not unpackable.is_unpacked():
			unpackable.unpack(delta)
		elif unpackable.last_pack_state == Unpackable.PackState.PACKED and not unpackable.is_packed():
			unpackable.pack(delta)

	_being_used = false


func _on_unpackable_finished_unpacking() -> void:
	finished_cooloff = true
	await get_tree().create_timer(1.0).timeout
	finished_cooloff = false
	carryable.enabled = false


func _on_unpackable_finished_packing() -> void:
	finished_cooloff = true
	await get_tree().create_timer(1.0).timeout
	finished_cooloff = false
	carryable.enabled = true
