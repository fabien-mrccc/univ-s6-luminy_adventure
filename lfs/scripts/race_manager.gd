extends Node3D

var race_started := false
var race_time := 0.0

func start_race():
	race_started = true
	race_time = 0.0
	print("Course démarrée")
