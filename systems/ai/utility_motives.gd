extends Resource
class_name UtilityMotives

@export var fullness := 0.0
@export var energy := 0.0
@export var security := 0.0
@export var fun := 0.0
@export var health := 0.0
@export var space := 0.0


func add_on(base:UtilityMotives) -> void:
    if base == null:
        return

    fullness += base.fullness
    energy += base.energy
    security += base.security
    fun += base.fun
    health += base.health
    space += base.space

    fullness = clampf(fullness, 0.0, 1.0)
    energy = clampf(energy, 0.0, 1.0)
    security = clampf(security, 0.0, 1.0)
    fun = clampf(fun, 0.0, 1.0)
    health = clampf(health, 0.0, 1.0)
    space = clampf(space, 0.0, 1.0)