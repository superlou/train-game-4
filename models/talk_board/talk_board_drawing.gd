@tool
extends Node2D
class_name TalkBoardDrawing

@onready var message_label: Label = $MessageLabel
@onready var options_container: Container = $OptionsContainer
@onready var font: Font = preload("res://assets/fonts/ShadowsIntoLight-Regular.ttf")

signal changed_options(option_transforms:Array)

@export var message := "":
	set(value):
		message = value
		update_message()

@export var options: Array[String] = []:
	set(value):
		options = value
		update_options()


func _ready() -> void:
	update_message()
	update_options()


func update_message():
	if not message_label:
		return
	
	message_label.text = message


func update_options():
	if not options_container:
		return

	for child in options_container.get_children():
		options_container.remove_child(child)
		child.free()
	
	for option in options:
		var option_label := Label.new()
		
		option_label.text = option
		option_label.size_flags_horizontal |= Control.SIZE_EXPAND
		option_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		option_label.add_theme_font_override("font", font)
		option_label.add_theme_font_size_override("font_size", 96)
		option_label.add_theme_color_override("font_color", Color(0, 0, 0))
		options_container.add_child(option_label)

	# Need two frames to make sure layout happens.
	# todo Figure out something better
	await get_tree().process_frame
	await get_tree().process_frame

	var option_transforms := options_container.get_children().map(func (label:Label):
		return {
			"option": label.text,
			"position": label.global_position,
			"size": label.size
		}
	)

	changed_options.emit(option_transforms)


func select(option_idx: int):
	var option_label:Label = options_container.get_child(option_idx)
	var stylebox := StyleBoxFlat.new()
	stylebox.draw_center = false
	stylebox.set_border_width_all(6)
	stylebox.border_color = Color(0, 0, 0)
	option_label.add_theme_stylebox_override("normal", stylebox)
