extends CharacterBody3D

@export var walk_speed := 1.0 		# m/s
@export var sprint_speed := 4.0 	# m/s
@export var jump_height := 1.0 		# m

@onready var nav:NavigationAgent3D = $NavigationAgent

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var grav_vel := Vector3.ZERO
var jump_vel: Vector3
var platform_vel_at_jump := Vector3.ZERO
var jumping := false

var navigating := false
var nav_target:Marker3D = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta:float) -> void:
	if not navigating:
		var targets := get_tree().get_nodes_in_group("nav_marker")

		for target in targets:
			if nav_target != target:
				nav_target = target
				navigating = true
				break
		
		print(nav_target)
	
	if navigating:
		_move_towards_nav_target()


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


func _move_towards_nav_target():
	nav.target_position = nav_target.global_position
	nav.velocity = (nav.get_next_path_position() - global_position).normalized() * walk_speed


func _on_navigation_agent_velocity_computed(safe_velocity:Vector3) -> void:
	var delta := get_physics_process_delta_time()

	_jump(delta)
	# print(jump_vel)
	# if jump_vel.length() != 0.0:
	# 	safe_velocity = Vector3.ZERO

	velocity = safe_velocity + _gravity(delta) + jump_vel
	rotation.y = atan2(safe_velocity.x, safe_velocity.z)
	move_and_slide()


func _on_navigation_agent_navigation_finished() -> void:
	navigating = false


func _on_navigation_agent_link_reached(_details:Dictionary) -> void:
	if not $JumpTestRay.is_colliding():
		jumping = true
