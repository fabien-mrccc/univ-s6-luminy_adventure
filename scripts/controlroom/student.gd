## Handles a student's animation and movement along a predefined path, including decision outcomes.
extends Node3D

## Speed when walking forward.
@export var forward_speed: float = 3.0

## Speed when returning after refusal.
@export var return_speed: float = 3.0

## Stop position at the checkpoint.
@export var stop_position: float = 14.3

## Final destination position after acceptance.
@export var end_position: float = 25.78

## Emitted when the student arrives at the checkpoint.
signal arrived_at_guichet

## Emitted when the student has completed their interaction and exited.
signal interaction_complete

## Internal state flags.
var has_arrived: bool = false
var is_waiting: bool = false
var is_returning: bool = false
var is_continuing: bool = false
var has_emitted_arrival: bool = false

@onready var path_follow: PathFollow3D = get_parent()
@onready var anim_player: AnimationPlayer = $AnimationPlayer

## Dialogue line shown when the student arrives.
@export var dialogue_text: String = "Bonjour voici mes documents,\ncela vous conviens ou pas ?"

## Resets the student's state and position on the path.
func reset_state() -> void:
	has_arrived = false
	is_waiting = false
	is_returning = false
	is_continuing = false
	has_emitted_arrival = false

	path_follow.progress = 0.0
	path_follow.progress_ratio = 0.0
	rotation.y = 0.0
	visible = true
	anim_player.play("Walk")

## Starts walking animation and resets state.
func start_walk() -> void:
	reset_state()
	anim_player.play("Walk")

func _ready() -> void:
	anim_player.play("Walk")

func _process(delta: float) -> void:
	if is_returning:
		path_follow.progress -= return_speed * delta
		if path_follow.progress <= 0.0:
			path_follow.progress = 0.0
			emit_signal("interaction_complete")

	elif not has_arrived:
		path_follow.progress += forward_speed * delta
		if path_follow.progress >= stop_position:
			path_follow.progress = stop_position
			has_arrived = true
			is_waiting = true
			if not has_emitted_arrival:
				anim_player.stop()
				emit_signal("arrived_at_guichet")
				has_emitted_arrival = true

	elif is_continuing:
		path_follow.progress += forward_speed * delta
		if path_follow.progress >= end_position:
			path_follow.progress = end_position
			emit_signal("interaction_complete")

## Called when the student is accepted and should continue forward.
func continue_after_accept() -> void:
	is_waiting = false
	is_continuing = true
	anim_player.play("Walk")
	await get_tree().create_timer(2.0).timeout
	emit_signal("interaction_complete")

## Called when the student is refused and should return.
func go_back() -> void:
	is_waiting = false
	is_returning = true
	anim_player.play("Walk")
	rotation_degrees.y = 180.0
