extends Area3D
class_name Interactable

@export var has_hold_interaction := false

var hold_interaction_threshold := 0.1
var interaction_duration := 0.0
var was_interacted_with := false
var is_hovered := false :
    set(value):
        if value and not is_hovered:
            hovered.emit()
        elif not value and is_hovered:
            unhovered.emit()

        is_hovered = value

enum InteractionType {
    GRAB,
    GRABBING,
    USE,
    USING,
}

signal hovered()
signal unhovered()
signal used(interactor: Interactor)
signal using(interactor: Interactor)
signal grabbed(interactor: Interactor)


func _ready() -> void:
    # Must be (only) on the interactable layer
    collision_layer = 2


func interact(interaction_type:InteractionType, interactor:Interactor):
    match interaction_type:
        InteractionType.USE:
            used.emit(interactor)
        InteractionType.USING:
            using.emit(interactor)
        InteractionType.GRAB:
            grabbed.emit(interactor)
