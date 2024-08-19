extends Node3D


signal pressed
@export var guard_color := Color(0.255, 0.255, 0.255)
@export var cap_color := Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	var guard_material:StandardMaterial3D = $Guard.mesh.surface_get_material(0).duplicate()
	guard_material.albedo_color = guard_color
	$Guard.mesh.surface_set_material(0, guard_material)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_interacted(interactor:Interactor):
	pressed.emit()
	$AnimationPlayer.play("Press")
