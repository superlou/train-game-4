@tool
extends Node3D

@export_range(-0.1, 1.1) var value := 0.5
@export_range(0.0, 1.0) var damping := 0.0
@export var color := Color.BLACK :
	get:
		return color
	set(value):
		color = value
		$Liquid.get_surface_override_material(0).albedo_color = color

var prev_value = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# todo This equation is not good
	# Consider https://stackoverflow.com/questions/1023860/exponential-moving-average-sampled-at-varying-times
	var new_value:float = (1.0 - damping) * value + damping * prev_value
	prev_value = new_value
	$Liquid.scale.y = remap(new_value, -0.05, 1.05, 0, 1)

func _on_element_store_changed_fuel_qty(qty:float) -> void:
	value = qty
