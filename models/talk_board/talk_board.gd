@tool
extends RigidBody3D
class_name TalkBoard


@export var message := "":
	set(value):
		message = value
		update_message()

@export var options: Array[String] = []:
	set(value):
		options = value
		update_options()

signal selected(value: String)

@onready var interactables = $Interactables
@onready var talk_board_drawing: TalkBoardDrawing = %TalkBoardDrawing


func _ready() -> void:
	update_message()
	update_options()


func update_message():
	if not talk_board_drawing:
		return
	
	talk_board_drawing.message = message


func update_options():
	if not talk_board_drawing:
		return
	
	talk_board_drawing.options = options


func _on_talk_board_drawing_changed_options(_option_infos: Array) -> void:
	pass
	# for interactable in interactables.get_children():
	# 	interactables.remove_child(interactable)
	# 	interactable.free()

	# for option in option_infos:
	# 	var interactable := Interactable.new()
	# 	var label_position = (option.position / 1024) - Vector2(0.5, 0.5)

	# 	print(label_position)


func _on_interactable_12_used(_interactor: Interactor) -> void:
	_select_idx(0)


func _on_interactable_22_used(_interactor: Interactor) -> void:
	_select_idx(1)


func _select_idx(idx: int) -> void:
	talk_board_drawing.select(idx)
	selected.emit(options[idx])
