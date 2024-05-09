extends SubViewport
class_name CCCameraSubViewport

@onready var camera = get_child(0)
@onready var initial_transform:Transform3D = camera.global_transform


func _process(_delta):
	camera.global_transform = get_parent().global_transform * initial_transform

