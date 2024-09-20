extends RigidBody3D


@onready var nav:NavigationAgent3D = $NavigationAgent

var nav_target:Marker3D = null
var nav_velocity := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta:float) -> void:
	if nav_target == null:
		var targets := get_tree().get_nodes_in_group("nav_marker")
		for target in targets:
			if nav_target != target:
				nav_target = target
	
	if nav_target:
		_move_towards_nav_target()

	apply_central_force(nav_velocity * 100)


func _move_towards_nav_target():
	nav.target_position = nav_target.global_position
	nav.velocity = (nav.get_next_path_position() - global_position).normalized()


func _on_navigation_agent_velocity_computed(safe_velocity:Vector3) -> void:
	print(safe_velocity)
	nav_velocity = safe_velocity
