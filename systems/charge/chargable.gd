class_name Chargable
extends Node

signal charge_changed(charge:float)
signal charge_emptied()

@export var max_charge := 100.0
@export var min_charge := 0.0
@export var charge := 50.0
@export var target := Node3D

var charge_queue := 0.0

func modify_charge(amount: float):
	charge_queue += amount

func _physics_process(_delta):
	var prev_charge := charge

	if charge_queue != 0:
		charge += charge_queue
		charge = clampf(charge, min_charge, max_charge)

		if charge != prev_charge:
			charge_changed.emit(charge)
			if charge == 0.0:
				charge_emptied.emit()
	
	charge_queue = 0.0