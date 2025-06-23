extends Node3D

@onready var chrono_label = $CanvasLayer/ChronoLabel

var race_started := false
var race_time := 0.0

func _physics_process(delta: float) -> void:
	if race_started:
		race_time += delta
		chrono_label.text = "Temps : %.2f s" % race_time

func start_race():
	race_started = true
	race_time = 0.0
