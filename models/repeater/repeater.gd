extends ShiftRigidBody


const MIN_NEEDLE_ANGLE := deg_to_rad(-45)
const MAX_NEEDLE_ANGLE := deg_to_rad(45)
const LPF_ALPHA := 0.1

var prev_strength := 0.0


func _strength_to_angle(strength: float) -> float:
	strength = clampf(strength, 0., 1.)
	var angle := MIN_NEEDLE_ANGLE * (1 - strength) + MAX_NEEDLE_ANGLE * (strength)
	return -angle


var t = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var strength:float = $RssiReceiver.strength + 0.1 * (randf() - 0.5)
	strength = prev_strength * (1. - LPF_ALPHA) + strength * LPF_ALPHA
	$RepeaterNeedle.rotation.x = _strength_to_angle(strength)
	prev_strength = strength

	$RssiArea.disabled = $RssiReceiver.strength <= 0.0

