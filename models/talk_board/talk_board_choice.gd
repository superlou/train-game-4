@tool
extends Node3D
class_name TalkBoardChoice


@onready var label:Label3D = $Label

@export var choice := "Choice" :
	set(value):
		choice = value
		update_label()


func _ready() -> void:
	update_label()


func update_label():
	if label:
		label.text = choice
