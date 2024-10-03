extends CharacterBody3D

@export var walk_speed := 1.0 		# m/s
@export var sprint_speed := 4.0 	# m/s

@onready var nav:NavigationAgent3D = $NavigationAgent
@onready var animation:AnimationPlayer = $PersonModel/AnimationPlayer

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var grav_vel := Vector3.ZERO

var navigating := false
var nav_reached_target := false
var nav_target:Vector3 = Vector3.ZERO


func _ready() -> void:
	pass


func _physics_process(_delta:float) -> void:
	if navigating:
		_move_towards_nav_target()


func _gravity(delta: float) -> Vector3:
	if is_on_floor():
		grav_vel = Vector3.ZERO
	else:
		grav_vel = grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	
	return grav_vel


var wants_leap := false
var is_leaping := false
var leap_target := Vector3.ZERO
var leap_vel := Vector3.ZERO


func _leap(delta: float) -> Vector3:
	# Check if we want to initiate a leap
	if wants_leap and is_on_floor():
		# todo this should be a function of how high/hard we leap, i.e., hang time
		var travel_vel := leap_target - global_position
		var leap_height := 0.5
		leap_vel = Vector3(travel_vel.x, sqrt(4 * leap_height * gravity), travel_vel.z)
		is_leaping = true
		wants_leap = false
		return leap_vel

	# Handle leaping
	if is_leaping and not is_on_floor():
		leap_vel = leap_vel.move_toward(Vector3.DOWN * gravity, delta)
	else:
		leap_vel = Vector3.ZERO
		is_leaping = false
	
	return leap_vel


func _move_towards_nav_target():
	nav.target_position = nav_target #.global_position
	nav.velocity = (nav.get_next_path_position() - global_position).normalized() * walk_speed


func _on_navigation_agent_velocity_computed(safe_velocity:Vector3) -> void:
	var delta := get_physics_process_delta_time()

	var move_velocity := Vector3(safe_velocity.x, 0.0, safe_velocity.z)

	if is_leaping or wants_leap:
		velocity = _leap(delta) + _gravity(delta)
	else:
		velocity = move_velocity + _gravity(delta)
	
	if velocity.x != 0.0 or velocity.z != 0.0:
		rotation.y = atan2(velocity.x, velocity.z)

	if absf(velocity.x) < 0.001 and absf(velocity.z) < 0.001:
		animation.play("Idle")
	else:
		animation.play("Walk")

	move_and_slide()


func _on_navigation_agent_navigation_finished() -> void:
	print("finished nav. reached = ", nav_reached_target)
	navigating = false


func _on_navigation_agent_target_reached() -> void:
	nav_reached_target = true


func _on_navigation_agent_link_reached(details:Dictionary) -> void:
	if not $JumpTestRay.is_colliding() and not is_leaping:
		leap_target = details["link_exit_position"]
		wants_leap = true


func _on_person_ai_picked_movement_goal(pos:Vector3) -> void:
	nav_target = pos
	navigating = true
	nav_reached_target = false