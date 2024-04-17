extends Node3D

enum RampState {
	STOWED,
	EXTENDING,
	OUT,
	LIFTING,
	RETRACTING,
}

enum DeployDir {
	LEFT,
	RIGHT,
}

var state := RampState.STOWED
var deploy_dir := DeployDir.LEFT

@export var deploy_speed := 1.0
@onready var plate: RigidBody3D = $Plate

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(_delta):
	if Input.is_action_just_pressed("extend_ramp_left"):
		print("here")
		deploy_dir = DeployDir.LEFT
		state = RampState.EXTENDING
	elif Input.is_action_just_pressed("extend_ramp_right"):
		deploy_dir = DeployDir.RIGHT
		state = RampState.EXTENDING
	elif Input.is_action_just_pressed("stow_ramp") and state == RampState.OUT:
		state = RampState.LIFTING


func _physics_process(_delta: float):
	print(state)
	if state == RampState.EXTENDING:
		plate.sleeping = false

		var joint := $SlideJoint
		joint["linear_limit_x/enabled"] = true
		joint["linear_limit_y/enabled"] = true
		joint["linear_limit_z/enabled"] = false
		joint["linear_motor_z/enabled"] = true
		var target_velocity := deploy_speed if deploy_dir == DeployDir.LEFT else -deploy_speed
		joint["linear_motor_z/target_velocity"] = target_velocity

		joint.enabled = true

		var at_pivot := false

		if deploy_dir == DeployDir.LEFT and plate.position.z < -3.24:
			at_pivot = true
		elif deploy_dir == DeployDir.RIGHT and plate.position.z > 3.24:
			at_pivot = true
		
		if at_pivot:
			joint.enabled = false
			state = RampState.OUT
	elif state == RampState.OUT:
		var joint := $LeftHingeJoint if deploy_dir == DeployDir.LEFT else $RightHingeJoint
		joint.node_a = ^"../Plate"
		joint.enabled = true
	elif state == RampState.LIFTING:
		var joint := $LeftHingeJoint if deploy_dir == DeployDir.LEFT else $RightHingeJoint
		joint.motor_enabled = true
		joint.motor_target_velocity = -0.1 if deploy_dir == DeployDir.LEFT else 0.1

		var ready_to_retract := false

		if deploy_dir == DeployDir.LEFT and plate.rotation.x >= 0:
			ready_to_retract = true
		elif deploy_dir == DeployDir.RIGHT and plate.rotation.x <= 0:
			ready_to_retract = true
		
		if ready_to_retract:
			joint.motor_enabled = false
			joint.enabled = false
			state = RampState.RETRACTING
	elif state == RampState.RETRACTING:
		var joint := $SlideJoint
		var target_velocity := -deploy_speed if deploy_dir == DeployDir.LEFT else deploy_speed
		joint["linear_motor_z/target_velocity"] = target_velocity
		joint.enabled = true

		var at_stow_point := false

		if deploy_dir == DeployDir.LEFT and plate.position.z >= 0.0:
			at_stow_point = true
		elif deploy_dir == DeployDir.RIGHT and plate.position.z <= 0.0:
			at_stow_point = true

		if at_stow_point:
			print("at_stow_point")
			joint.enabled = false
			state = RampState.STOWED
