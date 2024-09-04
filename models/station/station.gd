extends StaticBody3D


@export var station_name := "Unnamed"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_build()


func _build() -> void:
	$Sign.text = station_name.to_upper() + " STATION"
	$Sign2.text = station_name.to_upper() + " STATION"