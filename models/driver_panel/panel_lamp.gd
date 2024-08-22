@tool
extends Node3D


@export var active := false
@export var color := Color.WHITE

@onready var lamp_material:StandardMaterial3D = $Lamp.get_surface_override_material(0)


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active:
		lamp_material.albedo_color = color
		lamp_material.emission = color		
		lamp_material.emission_enabled = true
	else:
		lamp_material.albedo_color = color.darkened(0.7)
		lamp_material.emission = Color.BLACK
		lamp_material.emission_enabled = false