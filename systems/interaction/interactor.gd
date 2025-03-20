extends Node3D
class_name Interactor


@export var carrier:Carrier = null


func get_closest_interactable() -> Interactable:
	var hit: Area3D = $RayCast3D.get_collider()
	return hit as Interactable
