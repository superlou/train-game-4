extends CharacterBody3D

signal died(player)

@export var walk_speed := 1.0 		# m/s
@export var sprint_speed := 2.0 	# m/s
@export var acceleration := 10.0 	# m/s^2
@export var jump_height := 1.0 		# m

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity: float = ProjectSettings.get_setting("player/look_sensitivity")

var move_dir: Vector2	# Input direction for movement
var look_dir: Vector2	# Input direction for look/aim

var walk_vel: Vector3
var grav_vel: Vector3
var jump_vel: Vector3

var mouse_captured := false
var jumping := false


func _ready():
	capture_mouse()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if mouse_captured:
			_rotate_camera(event)

	if Input.is_action_just_pressed("jump"):
		jumping = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		if mouse_captured:
			release_mouse()
		else:
			capture_mouse()


func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


func _physics_process(delta):
	var speed = sprint_speed if Input.is_action_pressed("sprint") else walk_speed

	velocity = _walk(delta, speed) +_gravity(delta) + _jump(delta)
	move_and_slide()

	$Chargable.modify_charge(-10.0 * delta)


func _walk(delta: float, speed: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var forward: Vector3 = %Camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir := Vector3(forward.x, 0, forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel


func _gravity(delta: float) -> Vector3:
	if is_on_floor():
		grav_vel = Vector3.ZERO
	else:
		grav_vel = grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	
	return grav_vel


func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor():
			jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		
		jumping = false
		return jump_vel
	
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel


func _rotate_camera(event: InputEventMouseMotion) -> void:
	rotate_y(event.relative.x * -look_sensitivity)
	%Camera.rotate_x(event.relative.y * -look_sensitivity)
	%Camera.rotation.x = clamp(%Camera.rotation.x, -PI/2, PI/2)


func _on_chargable_charge_changed(charge:float):
	# todo Make some graphics
	var label: RichTextLabel = $RichTextLabel
	if charge > 99:
		label.text = "||||"
	elif charge > 80:
		label.text = "|||."
	elif charge > 70:
		label.text = "|||"
	elif charge > 60:
		label.text = "||."
	elif charge > 50:
		label.text = "||"
	elif charge > 40:
		label.text = "||"
	elif charge > 30:
		label.text = "|."
	elif charge > 20:
		label.text = "|"
	elif charge > 10:
		label.text = "."
	else:
		label.text = ""



func _on_chargable_charge_emptied():
	died.emit(self)
