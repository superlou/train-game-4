extends Node3D


var accel := 4.0
var speed := 0.0


@onready var props:Node3D = $Props
@export var shift_limit := 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("accelerate_right"):
		speed += accel * delta
	elif Input.is_action_pressed("accelerate_left"):
		speed -= accel * delta
	elif Input.is_action_pressed("apply_break"):
		speed = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Car.position.x += speed * delta
	print($Car.position.x)

	var shift := 0.0

	if $Car.position.x >= shift_limit:
		shift = -1.0
	elif $Car.position.x <= -shift_limit:
		shift = 1.0
		
	if shift:
		$Ground.position.x += shift * shift_limit
		$Car.position.x += shift * shift_limit
		for prop in props.get_children():
			prop.shift = shift * shift_limit - speed * delta