extends CanvasLayer


@export var strength := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	visible = strength > 0.001

	var material:ShaderMaterial = $NoiseRect.material
	material.set_shader_parameter("curvature", 2 * strength)
	material.set_shader_parameter("skip", 0.5 * strength)
	material.set_shader_parameter("image_flicker", strength)
	material.set_shader_parameter("vignette_strength", strength)
	material.set_shader_parameter("small_scanlines_opacity", strength)
	material.set_shader_parameter("scanlines_opacity", strength)
	material.set_shader_parameter("noise_strength", 0.5 * strength)
