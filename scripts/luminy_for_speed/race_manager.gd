extends Node3D

@onready var player_car = $PlayerCar/Car_LFS
@onready var finish_line = $FinishLine
@onready var off_road_right = $OffRoadRight
@onready var off_road_left = $OffRoadLeft

var race_started := false
var race_time := 0.0

func _ready() -> void:
	print("Appuyer sur 'Z' pour démarrer la course")
	finish_line.body_entered.connect(_on_finish_line_entered)
	off_road_left.body_exited.connect(_on_offroad_zone_exited)
	off_road_right.body_exited.connect(_on_offroad_zone_exited)

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

func _on_finish_line_entered(body):
	if body == player_car and race_started:
		race_started = false
		print("Temps final: %.2f secondes" % race_time)

func _on_offroad_zone_exited(body):
	if body == player_car:
		var z_pos = body.global_position.z
		var respawn_pos = Vector3(0, 1, z_pos)
		body.global_position = respawn_pos
		body.linear_velocity = Vector3.ZERO
		body.angular_velocity = Vector3.ZERO
