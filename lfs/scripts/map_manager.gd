extends Node3D

@onready var chrono_label = $CanvasLayer/ChronoLabel
@onready var player_car = $PlayerCar/Car_010
@onready var finish_line = $FinishLine
@onready var off_road_zones = $OffRoadZones
@onready var countdown_label = $CanvasLayer/CountdownLabel

var race_started := false
var race_time := 0.0

func _ready() -> void:
	finish_line.body_entered.connect(_on_finish_line_entered)
	off_road_zones.body_exited.connect(_on_offroad_zone_exited)
	chrono_label.text = ""
	start_countdown()

func _physics_process(delta: float) -> void:
	if race_started:
		race_time += delta
		chrono_label.text = "Temps : %.2f s" % race_time
	if Input.is_action_just_pressed("move_forward") and not race_started:
		start_race()

func start_countdown():
	var countdown = ["3", "2", "1", "GO!"]
	var delay = 1.0
	for i in countdown.size():
		countdown_label.text = countdown[i]
		await get_tree().create_timer(delay).timeout
	countdown_label.text = ""
	start_race()

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
