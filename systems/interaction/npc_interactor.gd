extends Interactor
class_name NPCInteractor


func try_interact_with(interactable:Interactable):
	# if carried_obj:
	# 	interact(carried_obj.get_node("Carryable"))
	# else:
	# 	if interactable:
	# 		interact(interactable)

	if carrier and carrier.carryable:
		carrier.carryable.interact(self)
	else:
		if interactable:
			interactable.interact(self)
