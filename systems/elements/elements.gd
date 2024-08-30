extends Node
class_name Elements

enum Type {
	FUEL,
	FOOD,
	MATERIAL,
	TECH,
}

@export_group("Provides", "provides_")
@export var provides_fuel := 0.0
@export var provides_food := 0.0
@export var provides_material := 0.0
@export var provides_tech := 0.0

@export_group("Requires", "requires_")
@export var requires_sames_as_provides := true
@export var requires_fuel := 0.0
@export var requires_food := 0.0
@export var requires_material := 0.0
@export var requires_tech := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
