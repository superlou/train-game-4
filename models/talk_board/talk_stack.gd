extends Node3D
class_name TalkStack


var TalkBoard := preload("res://models/talk_board/talk_board.tscn")

signal selected(value: String)
var talk_board: TalkBoard = null
var last_talk_board: TalkBoard = null


func _ready() -> void:
	$Placeholder.queue_free()
	remove_child($Placeholder)

	talk_board = TalkBoard.instantiate()
	talk_board.message = "Talk Board Message"
	talk_board.options = ["Yes", "No"]
	talk_board.selected.connect(_talk_board_selected)
	add_child(talk_board)


func _talk_board_selected(value: String) -> void:
	selected.emit(value)


func show_next_talkboard(message: String, options: Array[String]) -> void:
	print(message)
	print(options)
	last_talk_board = talk_board
	last_talk_board.freeze = false

	talk_board = TalkBoard.instantiate()
	talk_board.message = message
	talk_board.options = options
	talk_board.selected.connect(_talk_board_selected)
	add_child(talk_board)

	await get_tree().create_timer(0.5).timeout
	last_talk_board.queue_free()
