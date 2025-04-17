@tool
extends Node3D
class_name PanelButton


signal pressed
@export var guard_color := Color(0.255, 0.255, 0.255, 1.0)
@export var cap_color := Color.WHITE
@export var label := "" :
	get:
		return label
	set(value):
		label = value
		_update_label()


# Called when the node enters the scene tree for the first time.
func _ready():
	var guard_material:StandardMaterial3D = $Guard.get_surface_override_material(0)
	guard_material.albedo_color = guard_color
	_update_label()


func _update_label():
	$Cap/Label.text = label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_used(interactor:Interactor) -> void:
	pressed.emit()
	$AnimationPlayer.play("Press")
