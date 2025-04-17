extends RelativeBody


@export var unrolled := false

@onready var carryable := $Carryable


func _ready() -> void:
	if unrolled:
		$AnimationPlayer.play("Unrolled")
		carryable.enabled = false
	else:
		$AnimationPlayer.play("Roll-Up")
		$AnimationPlayer.seek(2)
		carryable.enabled = true


func _on_interactable_used(interactor:Interactor) -> void:
	if unrolled:
		$AnimationPlayer.play("Roll-Up")
		carryable.enabled = true
	else:
		$AnimationPlayer.play_backwards("Roll-Up")
		carryable.enabled = false

	unrolled = not unrolled