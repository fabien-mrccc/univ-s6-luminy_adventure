extends Node3D

@onready var chrono_label = $CanvasLayer/ChronoLabel
@onready var player_car = $PlayerCar/Car_010

var race_started := false
var race_time := 0.0

func _physics_process(delta: float) -> void:
	if race_started:
		race_time += delta
		chrono_label.text = "Temps : %.2f s" % race_time

func start_race():
	race_started = true
	race_time = 0.0

func _on_finish_line_entered(body):
	if body == player_car and race_started:
		race_started = false
		chrono_label.text = "Temps final : %.2f s" % race_time
		
func _on_offroad_zone_exited(body):
	if body == player_car:
		var z_pos = body.global_position.z
		var respawn_pos = Vector3(0, 10, z_pos)
		body.global_position = respawn_pos
		body.linear_velocity = Vector3.ZERO
		body.angular_velocity = Vector3.ZERO
