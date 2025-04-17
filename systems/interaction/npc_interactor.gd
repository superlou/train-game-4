extends Interactor
class_name NPCInteractor

const InteractionType = Interactable.InteractionType


func try_interact_by(interaction_type:InteractionType, interactable:Interactable):
	if carrier and carrier.carryable and interaction_type == InteractionType.GRAB:
		carrier.carryable.interact(self)
	else:
		if interactable:
			interactable.interact(interaction_type, self)
