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


func start_deploy(deploy_dir_: DeployDir) -> void:
	deploy_dir = deploy_dir_
	plate.sleeping = false
	plate.freeze = false
	state = RampState.EXTENDING


func start_stow() -> void:
	if state == RampState.OUT:
		plate.sleeping = false
		state = RampState.LIFTING


func _process(_delta):
	pass


enum LightsMode { OFF, WARN, SAFE }


func _set_lights(mode: LightsMode, dir: DeployDir):
	match mode:
		LightsMode.OFF:
			$LeftWarnLight.set_state(false)
			$RightWarnLight.set_state(false)
			$LeftSafeLight.set_state(false)
			$RightSafeLight.set_state(false)
		LightsMode.WARN:
			$LeftSafeLight.set_state(false)
			$RightSafeLight.set_state(false)
			if dir == DeployDir.LEFT:
				$LeftWarnLight.set_state(true, true)
				$RightWarnLight.set_state(false)
			elif dir == DeployDir.RIGHT:
				$LeftWarnLight.set_state(false)
				$RightWarnLight.set_state(true, true)
		LightsMode.SAFE:
			$LeftWarnLight.set_state(false)
			$RightWarnLight.set_state(false)			
			if dir == DeployDir.LEFT:
				$LeftSafeLight.set_state(true)
				$RightSafeLight.set_state(false)
			elif dir == DeployDir.RIGHT:
				$LeftSafeLight.set_state(false)
				$RightSafeLight.set_state(true)	


func _physics_process(_delta: float):
	var gate = $GateLeft if deploy_dir == DeployDir.LEFT else $GateRight

	if state == RampState.EXTENDING:
		_set_lights(LightsMode.WARN, deploy_dir)

		var joint := $SlideJoint
		joint["linear_limit_x/enabled"] = true
		joint["linear_limit_y/enabled"] = true
		joint["linear_limit_z/enabled"] = false
		joint["linear_motor_z/enabled"] = true
		var target_velocity := deploy_speed if deploy_dir == DeployDir.LEFT else -deploy_speed
		joint["linear_motor_z/target_velocity"] = target_velocity
		joint.enabled = true

		var at_pivot := (deploy_dir == DeployDir.LEFT and plate.position.z < -3.24) or \
						(deploy_dir == DeployDir.RIGHT and plate.position.z > 3.24)
		
		if at_pivot:
			joint.enabled = false
			state = RampState.OUT
	elif state == RampState.OUT:
		gate.raise()
		_set_lights(LightsMode.SAFE if gate.state == "raised" else LightsMode.WARN, deploy_dir)

		var joint := $LeftHingeJoint if deploy_dir == DeployDir.LEFT else $RightHingeJoint
		joint.node_a = ^"../Plate"
		joint.enabled = true
	elif state == RampState.LIFTING:
		gate.lower()
		_set_lights(LightsMode.WARN, deploy_dir)
		
		var joint := $LeftHingeJoint if deploy_dir == DeployDir.LEFT else $RightHingeJoint
		joint.motor_enabled = true
		joint.motor_target_velocity = -0.1 if deploy_dir == DeployDir.LEFT else 0.1

		var ready_to_retract := (deploy_dir == DeployDir.LEFT and plate.rotation.x >= 0) or \
								(deploy_dir == DeployDir.RIGHT and plate.rotation.x <= 0)
		
		if ready_to_retract:
			joint.motor_enabled = false
			joint.enabled = false
			state = RampState.RETRACTING
	elif state == RampState.RETRACTING:
		_set_lights(LightsMode.WARN, deploy_dir)

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
			joint.enabled = false
			state = RampState.STOWED
	elif state == RampState.STOWED:
		_set_lights(LightsMode.OFF, deploy_dir)
		plate.freeze = true


func _on_right_gate_buttons_pressed(button:int):
	if button == 1:
		start_deploy(DeployDir.RIGHT)
	elif button == 2:
		start_stow()


func _on_left_gate_buttons_pressed(button:int):
	if button == 1:
		start_deploy(DeployDir.LEFT)
	elif button == 2:
		start_stow()
