extends Node3D

var race_started := false
var race_time := 0.0

func _physics_process(delta: float) -> void:
	if race_started:
		race_time += delta
		print("Temps: %.2f secondes" % race_time)
	if Input.is_action_just_pressed("move_forward") and not race_started:
		start_race()

func start_race():
	race_started = true
	race_time = 0.0
	print("Course démarrée")
