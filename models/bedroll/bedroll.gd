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
