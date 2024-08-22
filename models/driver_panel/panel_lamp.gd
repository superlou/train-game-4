@tool
extends Node3D


@export var active := false
@export var color := Color.WHITE

@onready var lamp_material:StandardMaterial3D = $Lamp.get_surface_override_material(0)

var brightness = 0.0

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active and (brightness < 1.0):
		brightness += 20.0 * delta
		brightness = clampf(brightness, 0.0, 1.0)
	elif not active and (brightness > 0.0):
		brightness -= 5.0 * delta
		brightness = clampf(brightness, 0.0, 1.0)
	
	lamp_material.emission = color
	lamp_material.emission_enabled = brightness > 0.1
	lamp_material.albedo_color = color.darkened(
		remap(brightness, 0., 1., 0.7, 0.0)
	)

	lamp_material.emission_energy_multiplier = brightness