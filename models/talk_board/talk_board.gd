@tool
extends Node3D
class_name TalkBoard

@export var message := "" :
	set(value):
		message = value
		if message_label:
			message_label.text = value
			fit_message()

@onready var message_label:Label3D = $MessageLabel

var max_message_height = 550

func _ready() -> void:
	message_label.text = message
	fit_message()


func fit_message():
	var font := message_label.font
	var font_size := 128

	var size := font.get_multiline_string_size(
		message,
		message_label.horizontal_alignment,
		message_label.width,
		font_size
	)

	# todo Make a binary search
	while size.y > max_message_height:
		font_size -= 1
		size = font.get_multiline_string_size(
			message,
			message_label.horizontal_alignment,
			message_label.width,
			font_size
		)
		print(size)

	message_label.font_size = font_size
