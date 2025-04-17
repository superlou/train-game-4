extends Node3D


signal pressed(button: int)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_left_button_interactable_interacted(interactor:Interactor):
	print(interactor)


func _on_interactable_1_used(_interactor:Interactor) -> void:
	pressed.emit(1)
	$AnimationPlayer.play("Press1")


func _on_interactable_2_used(_interactor:Interactor) -> void:
	pressed.emit(2)
	$AnimationPlayer.play("Press2")
