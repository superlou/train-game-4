extends Area3D
class_name Interactable

@export var has_hold_interaction := false

var hold_interaction_threshold := 0.1
var interaction_duration := 0.0
var was_interacted_with := false

enum InteractionType {
    GRAB,
    GRABBING,
    USE,
    USING,
}

# signal focused()
# signal unfocused()
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