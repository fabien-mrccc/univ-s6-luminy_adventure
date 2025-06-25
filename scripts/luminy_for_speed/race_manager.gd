## Manages the core logic of a car race: start, finish, and respawn if off-road.
extends Node3D

## Node references
@onready var player_car = $PlayerCar/Car_LFS
@onready var finish_line = $FinishLine
@onready var off_road_right = $OffRoadRight
@onready var off_road_left = $OffRoadLeft

## Race state
var race_started := false
var race_time := 0.0

func _ready() -> void:
	finish_line.body_entered.connect(_on_finish_line_entered)
	off_road_left.body_exited.connect(_on_offroad_zone_exited)
	off_road_right.body_exited.connect(_on_offroad_zone_exited)

func _physics_process(delta: float) -> void:
	if race_started:
		race_time += delta
	if Input.is_action_just_pressed("move_forward") and not race_started:
		start_race()

## Initializes race parameters
func start_race():
	race_started = true
	race_time = 0.0

## Handles player crossing the finish line
func _on_finish_line_entered(body):
	if body == player_car and race_started:
		race_started = false

## Handles player exiting the track area (off-road)
func _on_offroad_zone_exited(body):
	if body == player_car:
		var z_pos = body.global_position.z
		var respawn_pos = Vector3(0, 1, z_pos)
		body.global_position = respawn_pos
		body.linear_velocity = Vector3.ZERO
		body.angular_velocity = Vector3.ZERO
