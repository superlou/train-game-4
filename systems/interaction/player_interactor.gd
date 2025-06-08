extends Interactor
class_name PlayerInteractor

var _mouse_button_left_was_pressed := false
const InteractionType = Interactable.InteractionType

@onready var _reticule:TextureRect = $CenterContainer/ReticuleTexture
var _prev_interactable:Interactable = null


func _ready() -> void:
	_reticule.modulate = Color(1.0, 1.0, 1.0, 0.3)


func _process(_delta):
	var interactable = get_closest_interactable()
	_update_reticule(interactable)
	_update_hover(interactable)
	_prev_interactable = interactable

	# Handle action key press
	if Input.is_action_just_pressed("interact"):
		try_interact(InteractionType.GRAB, interactable)

	# Handle single mouse clicks
	var mouse_button_left_is_pressed := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if mouse_button_left_is_pressed and not _mouse_button_left_was_pressed:
		try_interact(InteractionType.USE, interactable)
	
	_mouse_button_left_was_pressed = mouse_button_left_is_pressed

	# Handle mouse hold
	if mouse_button_left_is_pressed:
		try_interact(InteractionType.USING, interactable)


func try_interact(interaction_type:InteractionType, interactable:Interactable):
	if carrier and carrier.carryable and interaction_type == InteractionType.GRAB:
		carrier.carryable.interact(self)
	else:
		if interactable:
			interactable.interact(interaction_type, self)


func _update_hover(interactable:Interactable) -> void:
	if interactable:
		interactable.is_hovered = true

	if _prev_interactable and _prev_interactable != interactable:
		_prev_interactable.is_hovered = false


func _update_reticule(interactable:Interactable) -> void:
	if carrier and carrier.carryable:
		_reticule.modulate = Color(1.0, 1.0, 1.0, 0.3)
		return

	if interactable != _prev_interactable:
		if interactable:
			_reticule.modulate = Color(1, 1, 1, 1)
		else:
			_reticule.modulate = Color(1.0, 1.0, 1.0, 0.3)
