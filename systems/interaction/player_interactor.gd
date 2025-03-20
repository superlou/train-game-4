extends Interactor
class_name PlayerInteractor


func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		try_interact()


func try_interact():
	if carrier and carrier.carryable:
		carrier.carryable.interact(self)
	else:
		var interactable = get_closest_interactable()
		if interactable:
			interactable.interact(self)
