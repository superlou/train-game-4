extends Interactor
class_name PlayerInteractor

var _mouse_button_left_was_pressed := false
const InteractionType = Interactable.InteractionType


func _process(_delta):
	# Handle action key press
	if Input.is_action_just_pressed("interact"):
		try_interact(InteractionType.GRAB)

	# Handle single mouse clicks
	var mouse_button_left_is_pressed := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if mouse_button_left_is_pressed and not _mouse_button_left_was_pressed:
		try_interact(InteractionType.USE)
	
	_mouse_button_left_was_pressed = mouse_button_left_is_pressed

	# Handle mouse hold
	if mouse_button_left_is_pressed:
		try_interact(InteractionType.USING)


func try_interact(interaction_type:InteractionType):
	if carrier and carrier.carryable and interaction_type == InteractionType.GRAB:
		carrier.carryable.interact(self)
	else:
		var interactable = get_closest_interactable()
		if interactable:
			interactable.interact(interaction_type, self)
