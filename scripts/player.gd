## Controls the player character's movement and camera behavior.
extends CharacterBody3D

## Movement speed in walk mode.
const WALK_SPEED := 5.0

## Movement speed in sprint mode.
const SPRINT_SPEED := 8.0

## Upward velocity applied when jumping.
const JUMP_VELOCITY := 4.8

## Mouse sensitivity for looking around.
const SENSITIVITY := 0.004

## Frequency of the headbob effect.
const BOB_FREQ := 2.4

## Amplitude of the headbob effect.
const BOB_AMP := 0.04

## Default camera field of view (FOV).
const BASE_FOV := 75.0

## Additional FOV based on speed.
const FOV_CHANGE := 1.5

## Acceleration due to gravity.
const GRAVITY := 9.8

## Current horizontal movement speed (walk or sprint).
var _speed: float

## Time accumulator used for headbob effect.
var _t_bob: float = 0.0

## Flag to activate motion lines shader
var is_sprinting = false

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var shader_material : ShaderMaterial = $MotionLinesCanvas/MotionLines.material


## Called when the node enters the scene tree.
## Captures the mouse and initializes the camera FOV.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = BASE_FOV

## Handles mouse motion for camera and head rotation.
## @param event: InputEventMouseMotion - Mouse motion event.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

## Applies movement, gravity, headbob and FOV update each frame.
## @param delta: float - Frame time.
func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_movement_input(delta)
	_apply_headbob(delta)
	_update_camera_fov(delta)
	move_and_slide()

## Applies gravity when in air or jump impulse when grounded.
## @param delta: float - Frame time.
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

## Updates horizontal movement input and effects.
## @param delta: float - Frame time.
func _handle_movement_input(delta: float) -> void:
	is_sprinting = Input.is_action_pressed("sprint")

	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var is_moving = input_dir.length() > 0  # Check if there is any movement input

	if is_sprinting and is_moving:
		_speed = SPRINT_SPEED
		shader_material.set_shader_parameter("sprint_active", 1)
	else:
		_speed = WALK_SPEED
		shader_material.set_shader_parameter("sprint_active", 0)

	var direction: Vector3 = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		velocity.x = direction.x * _speed if direction else lerp(velocity.x, 0.0, delta * 7.0)
		velocity.z = direction.z * _speed if direction else lerp(velocity.z, 0.0, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * _speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * _speed, delta * 3.0)

## Applies head bobbing camera movement effect.
## @param delta: float - Frame time.
func _apply_headbob(delta: float) -> void:
	_t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _calculate_headbob(_t_bob)

## Updates camera FOV based on movement speed.
## @param delta: float - Frame time.
func _update_camera_fov(delta: float) -> void:
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

## Calculates the bobbing offset for the camera.
## @param time: float - Time accumulator for bobbing.
## @return Vector3 - Offset to apply to the camera position.
func _calculate_headbob(time: float) -> Vector3:
	return Vector3(
		cos(time * BOB_FREQ / 2) * BOB_AMP,
		sin(time * BOB_FREQ) * BOB_AMP,
		0.0
	)

## Simulates a single physics step. Useful for unit testing.
## @param delta: float - Frame time.
func simulate_physics(delta: float) -> void:
	_physics_process(delta)
