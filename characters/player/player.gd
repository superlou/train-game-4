extends CharacterBody3D

signal died(player)

@export var crouch_speed := 0.7 	# m/s
@export var walk_speed := 2.0 		# m/s
@export var sprint_speed := 4.0 	# m/s
@export var acceleration := 10.0 	# m/s^2
@export var jump_height := 1.0 		# m
@export var rssi_effects_enabled := true

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity: float = ProjectSettings.get_setting("player/look_sensitivity")

var move_dir: Vector2	# Input direction for movement
var look_dir: Vector2	# Input direction for look/aim

var walk_vel: Vector3
var grav_vel: Vector3
var jump_vel: Vector3
var platform_vel_at_jump := Vector3.ZERO
var jumping := false

var mouse_captured := false
var is_crouching := false

const CAMERA_STAND_HEIGHT = 1.312
const CAMERA_CROUCH_HEIGHT = 0.8

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
		
	is_crouching = Input.is_action_pressed("crouch")


func _crouch(delta:float):
	if is_crouching:
		%Camera.position.y = move_toward(%Camera.position.y, CAMERA_CROUCH_HEIGHT, delta * 5.0)
	else:
		%Camera.position.y = move_toward(%Camera.position.y, CAMERA_STAND_HEIGHT, delta * 5.0)


func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


func _physics_process(delta):
	_crouch(delta)
	var speed := _determine_speed()

	if _do_step_up():
		velocity = _walk(delta, speed) + Vector3(0, speed, 0) #+ _jump(delta)
	else:
		velocity = _walk(delta, speed) +_gravity(delta) + _jump(delta)

	move_and_slide()


func _determine_speed() -> float:
	if is_crouching:
		return crouch_speed
	elif Input.is_action_pressed("sprint"):
		return sprint_speed
	else:
		return walk_speed


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
			platform_vel_at_jump = get_platform_velocity()
			jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0) + platform_vel_at_jump
		
		jumping = false
		# Remove ground velocity for first frame of the jump, otherwise it's double-counted.
		return jump_vel - platform_vel_at_jump
	
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.DOWN + platform_vel_at_jump, gravity * delta)
	return jump_vel


var was_on_wall := false

func _do_step_up() -> bool:
	var can_step:bool = $FeetRayCast.is_colliding() and !$StepUpRayCast.is_colliding()

	if is_on_wall():
		was_on_wall = true
		return can_step
	elif was_on_wall and can_step:
		return true
	else:
		was_on_wall = false
		return false


func _rotate_camera(event: InputEventMouseMotion) -> void:
	rotate_y(event.relative.x * -look_sensitivity)
	%Camera.rotate_x(event.relative.y * -look_sensitivity)
	%Camera.rotation.x = clamp(%Camera.rotation.x, -PI/2, PI/2)


func _on_rssi_receiver_strength_changed(val:float):
	if not rssi_effects_enabled:
		return

	$GlitchCanvas.strength = clampf(1.0 - val, 0.0, 1.0)

	if val <= 0.0:
		died.emit(self)
