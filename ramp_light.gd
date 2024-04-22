extends Node3D

@export var off_color := Color.BLACK
@export var on_color := Color.WHITE
@export var is_on := false
@export var is_blinking := false

var material := StandardMaterial3D.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	$RampLight.set_surface_override_material(0, material)
	$Light.light_color = on_color


func set_state(on: bool, blinking: bool = false):
	is_on = on
	is_blinking = blinking


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_color()


func _update_color():
	var illuminate;

	if is_blinking and is_on:
		illuminate = (Time.get_ticks_msec() / 500) % 2
	else:
		illuminate = is_on

	material.albedo_color = on_color if illuminate else off_color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED if illuminate else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	$Light.light_energy = 1.0 if illuminate else 0.0
