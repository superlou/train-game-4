extends Node
class_name ElementStore


@export var fuel_qty := 1000.0
@export var food_qty := 0.0
@export var material_qty := 0.0
@export var tech_qty := 0.0


signal changed_fuel_qty(qty:float)


func add(element:Elements.Type, qty:float) -> void:
	match element:
		Elements.Type.FUEL:
			fuel_qty += qty
			changed_fuel_qty.emit(fuel_qty)
		Elements.Type.FOOD:
			food_qty += qty
		Elements.Type.MATERIAL:
			material_qty += qty
		Elements.Type.TECH:
			tech_qty += qty


func take(element:Elements.Type, qty:float) -> float:
	var qty_taken := 0.0

	match element:
		Elements.Type.FUEL:
			qty_taken = min(qty, fuel_qty)
			fuel_qty -= qty_taken
		Elements.Type.FOOD:
			qty_taken = min(qty, food_qty)
			food_qty -= qty_taken
		Elements.Type.MATERIAL:
			qty_taken = min(qty, material_qty)
			material_qty -= qty_taken
		Elements.Type.TECH:
			qty_taken = min(qty, tech_qty)
			tech_qty -= qty_taken

	return qty_taken