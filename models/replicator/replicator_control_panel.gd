extends Node3D


var code := 0
signal entered_code(code:int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button:PanelButton in $Buttons.get_children():
		var value := button.name.replace("Button", "")
		button.connect("pressed", func(): _on_button_pressed(value))


func _on_button_pressed(value:String):
	match value:
		"Clear":
			code = 0
		"Enter":
			entered_code.emit(code)
			code = 0
		_:
			var digit = int(value)
			code = code * 10 + digit

	_update_code_lamps()


func _update_code_lamps():
	$Lamps/LampNum1.active = code > 0
	$Lamps/LampNum2.active = code > 9
	$Lamps/LampNum3.active = code > 99
	$Lamps/LampNum4.active = code > 999


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
