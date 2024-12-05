extends Node3D
class_name Interactor

var carried_obj:RigidBody3D = null
@export var carry_point:Marker3D = null


func interact(interactable: Interactable) -> void:
	interactable.interacted.emit(self)


func get_closest_interactable() -> Interactable:
	var hit: Area3D = $RayCast3D.get_collider()
	return hit as Interactable


func set_carried(obj:RigidBody3D):
	carried_obj = obj
