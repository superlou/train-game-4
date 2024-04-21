extends Node3D

@export var off_color := Color.BLACK
@export var on_color := Color.WHITE
@export var is_on := false

var material := StandardMaterial3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$RampLight.set_surface_override_material(0, material)


func set_state(on: bool):
	is_on = on


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_color()


func _update_color():
	material.albedo_color = on_color if is_on else off_color
	material.emission_enabled = is_on
