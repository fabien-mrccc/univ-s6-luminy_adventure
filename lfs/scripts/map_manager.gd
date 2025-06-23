extends Node3D

@onready var chrono_label = $CanvasLayer/ChronoLabel
@onready var player_car = $PlayerCar/Car_010
@onready var finish_line = $FinishLine
@onready var off_road_zones = $OffRoadZones
@onready var countdown_label = $CanvasLayer/CountdownLabel

var race_started := false
var race_time := 0.0
var countdown_started := false

func _ready() -> void:
	finish_line.body_entered.connect(_on_finish_line_entered)
	off_road_zones.body_exited.connect(_on_offroad_zone_exited)
	chrono_label.text = ""
	countdown_label.text = ""

func _physics_process(delta: float) -> void:
	if not countdown_started and Input.is_action_just_pressed("move_forward"):
		countdown_started = true
		start_countdown()
	if race_started:
		race_time += delta
		chrono_label.text = "Temps : %.2f s" % race_time

func start_countdown():
	var countdown = ["3", "2", "1", "GO!"]
	for step in countdown:
		countdown_label.text = step
		player_car.sleeping = true
		await get_tree().create_timer(1.0).timeout
		player_car.sleeping = false
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
		var original_transform = body.global_transform
		var forward = -original_transform.basis.z.normalized()
		var side_offset = original_transform.basis.x.normalized() * 0.5
		var respawn_pos = original_transform.origin + side_offset
		respawn_pos.y = 50.0
		body.global_transform.origin = respawn_pos
		body.global_transform.basis = original_transform.basis
		body.linear_velocity = Vector3.ZERO
		body.angular_velocity = Vector3.ZERO
