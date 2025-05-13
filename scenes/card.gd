extends Node3D

@onready var label = $Label3D
var value : int = 0

func set_value(v: int) -> void:
	await ready  # attend que tous les enfants soient chargés
	value = v
	label.text = str(value)
