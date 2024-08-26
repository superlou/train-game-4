extends AnimatableBody3D


enum ReplicatorState {
	OPEN,
	CLOSING,
	WORKING,
	OPENING,
}

var state := ReplicatorState.OPEN
var operation := -1		# -1 is no operation
var work_timer := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Open")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		ReplicatorState.OPEN:
			do_open_state()
		ReplicatorState.CLOSING:
			do_closing_state()
		ReplicatorState.WORKING:
			do_working_state(delta)
		ReplicatorState.OPENING:
			do_opening_state()


func do_open_state() -> void:
	if operation != -1:
		$AnimationPlayer.play("Close")
		state = ReplicatorState.CLOSING
		work_timer = 3.0


func do_closing_state() -> void:
	if not $AnimationPlayer.is_playing():
		state = ReplicatorState.WORKING


func do_working_state(delta:float) -> void:
	work_timer -= delta
	if work_timer <= 0.0:
		operation = -1
		$AnimationPlayer.play("Open")
		state = ReplicatorState.OPENING


func do_opening_state() -> void:
	if not $AnimationPlayer.is_playing():
		state = ReplicatorState.OPEN



func _on_replicator_control_panel_entered_code(code:int) -> void:
	operation = code
