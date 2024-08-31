extends Node
class_name ElementStore


@export var element_qtys = {
	Elements.Type.FUEL: 0.0,
	Elements.Type.FOOD: 0.0,
	Elements.Type.MATERIAL: 0.0,
	Elements.Type.TECH: 0.0,
}

@export var element_maxes = {
	Elements.Type.FUEL: 10_000.0,
	Elements.Type.FOOD: 1_000.0,
	Elements.Type.MATERIAL: 1_000.0,
	Elements.Type.TECH: 1_000.0,
}


signal changed_qty(element_type:Elements.Type, qty:float)


func _ready() -> void:
	for element_type in Elements.Type.values():
		changed_qty.emit(element_type, element_qtys[element_type])


func add(element:Elements.Type, qty:float) -> void:
	element_qtys[element] += qty
	element_qtys[element] = minf(element_qtys[element], element_maxes[element])
	changed_qty.emit(element, element_qtys[element])


func take(element:Elements.Type, qty:float) -> float:
	var qty_taken := minf(qty, element_qtys[element])
	element_qtys[element] -= qty_taken
	changed_qty.emit(element, element_qtys[element])
	return qty_taken
