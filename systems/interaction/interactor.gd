extends Node3D
class_name Interactor

@export var controller: Node3D

func interact(interactable: Interactable) -> void:
	interactable.interacted.emit(self)


func get_closest_interactable() -> Interactable:
	var hit: Area3D = $RayCast3D.get_collider()
	return hit as Interactable
