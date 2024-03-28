extends RigidBody3D

var walk_speed := 1.0
var sprint_speed := 3.0
var jump_strength := 200.0
var is_jumping := false
var jump_cooldown := 0.1
var jump_cooldown_count := 0.0
var jump_velocity := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var velocity := Vector3.ZERO

	if Input.is_action_pressed("left"):
		velocity.x -= 1
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
	
	if Input.is_action_pressed("up"):
		velocity.z -= 1
	
	if Input.is_action_pressed("down"):
		velocity.z += 1
	
	velocity = velocity.normalized()
	
	if Input.is_action_pressed("sprint"):
		velocity *= sprint_speed
	else:
		velocity *= walk_speed

	if is_jumping:
		jump_cooldown_count -= jump_cooldown * delta
		if is_on_floor() and jump_cooldown_count <= 0.0:
			is_jumping = false

	if Input.is_action_just_pressed("jump") and is_on_floor():
		apply_force(jump_strength * Vector3.UP)
		is_jumping = true
		jump_cooldown_count = jump_cooldown
		jump_velocity = velocity

	if is_jumping:
		move_and_collide(jump_velocity * delta)
	else:
		move_and_collide(velocity * delta)


func is_on_floor():
	if $FloorCast.is_colliding():
		return true
	else:
		return false
