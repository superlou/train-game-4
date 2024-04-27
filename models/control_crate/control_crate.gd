extends Node3D


var door_is_open := false


func _ready():
	pass # Replace with function body.


func _process(_delta):
	pass


func door_at_open():
	door_is_open = true


func door_at_closed():
	door_is_open = false


func _on_door_interactable_interacted(_interactor:Interactor):
	if door_is_open:
		$AnimationPlayer.play_backwards("DoorSwing")
	else:
		$AnimationPlayer.play("DoorSwing")
