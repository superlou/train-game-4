extends Interactor
class_name PlayerInteractor


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		try_interact()


func try_interact():
	if carried_obj:
		interact(carried_obj.get_node("Carryable"))
	else:
		var interactable = get_closest_interactable()
		if interactable:
			interact(interactable)