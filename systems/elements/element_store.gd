extends Node
class_name ElementStore


var fuel_qty := 1000.0
var food_qty := 0.0
var material_qty := 0.0
var tech_qty := 0.0


func _on_replicator_generated_element(element:int, amount:float) -> void:
	match element:
		ElementType.FUEL:
			fuel_qty += amount
		ElementType.FOOD:
			food_qty += amount
		ElementType.MATERIAL:
			material_qty += amount
		ElementType.TECH:
			tech_qty += amount