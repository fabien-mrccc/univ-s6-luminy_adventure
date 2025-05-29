## Controls the player character's movement and camera behavior.
extends CharacterBody3D

## Movement speed in walk mode.
const WALK_SPEED := 2.0

## Mouse sensitivity for looking around.
const SENSITIVITY := 0.004

## Default camera field of view (FOV).
const BASE_FOV := 90.0

## Camera offset for walk animation.
const WALK_OFFSET := 0.1

## Acceleration due to gravity.
const GRAVITY := 9.8

## Current horizontal movement speed.
var _speed: float

## Camera base position and target for smooth transition.
var base_camera_pos: Vector3
var camera_target_pos: Vector3


@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var animation_player: AnimationPlayer = $Head/Character_020/AnimationPlayer


## Called when the node enters the scene tree.
## Captures the mouse and initializes the camera FOV and positions.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = BASE_FOV
	base_camera_pos = camera.position
	camera_target_pos = base_camera_pos
	animation_player.play("Idle")

## Handles mouse motion for camera and head rotation.
## @param event: InputEventMouseMotion - Mouse motion event.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

## Applies movement, gravity, smooth camera update and FOV update each frame.
## @param delta: float - Frame time.
func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement_input(delta)

	# Smoothly interpolate camera position to avoid sharp transitions
	camera.position = camera.position.lerp(camera_target_pos, delta * 10.0)

	move_and_slide()

## Applies gravity when (possible in air or jump impulse when grounded).
## @param delta: float - Frame time.
func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= GRAVITY * delta

## Updates horizontal movement input and effects, animations and camera transition.
## @param delta: float - Frame time.
func _handle_movement_input(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var is_moving = input_dir.length() > 0 
	
	if is_moving:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk", 0.3)
			camera_target_pos = base_camera_pos - Vector3(0, 0, WALK_OFFSET)
	else:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle", 0.3)
			camera_target_pos = base_camera_pos

	_speed = WALK_SPEED

	var direction: Vector3 = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		velocity.x = direction.x * _speed if direction else lerp(velocity.x, 0.0, delta * 7.0)
		velocity.z = direction.z * _speed if direction else lerp(velocity.z, 0.0, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * _speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * _speed, delta * 3.0)

## Simulates a single physics step. Useful for unit testing.
## @param delta: float - Frame time.
func simulate_physics(delta: float) -> void:
	_physics_process(delta)
