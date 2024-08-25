extends Node3D


enum State {
	CLEARED,
	ENTERED_1,
	ENTERED_2,
	ENTERED_3,
	ENTERED_4,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button:PanelButton in $Buttons.get_children():
		var value := button.name.replace("Button", "")
		button.connect("pressed", func(): _on_button_pressed(value))


func _on_button_pressed(value:String):
	print(value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
