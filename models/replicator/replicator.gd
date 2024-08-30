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

signal generated_element(element:Elements.Type, amount:float)


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

	for body:Node3D in $ConversionArea.get_overlapping_bodies():
		var elements := body.find_child("Elements") as Elements
		if not elements:
			continue

		if elements.provides_fuel > 0:
			generated_element.emit(Elements.Type.FUEL, elements.provides_fuel)
		
		if elements.provides_food > 0:
			generated_element.emit(Elements.Type.FOOD, elements.provides_food)

		if elements.provides_material > 0:
			generated_element.emit(Elements.Type.MATERIAL, elements.provides_material)

		if elements.provides_tech > 0:
			generated_element.emit(Elements.Type.TECH, elements.provides_tech)

		body.queue_free()


func do_opening_state() -> void:
	if not $AnimationPlayer.is_playing():
		state = ReplicatorState.OPEN



func _on_replicator_control_panel_entered_code(code:int) -> void:
	operation = code
