extends Node3D


@onready var talk_stack = $TalkStack

func _on_talk_stack_selected(value:String) -> void:
	print(value)
	var options: Array[String] = ["Maybe", "OK"]
	talk_stack.show_next_talkboard("Second Message", options)
