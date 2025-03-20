extends Area3D
class_name Interactable

# signal focused()
# signal unfocused()
signal interacted(interactor: Interactor)


func _ready() -> void:
    # Must be on the interactable layer
    set_collision_layer_value(1, false)
    set_collision_layer_value(2, true)


func interact(interactor:Interactor):
    interacted.emit(interactor)