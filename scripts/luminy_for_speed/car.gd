## Controls a vehicle using keyboard input and toggles escape menu.
extends VehicleBody3D

## Maximum angle the front wheels can steer.
const MAX_STEERING := 0.2

## Maximum engine force applied when accelerating.
const MAX_ENGINE_FORCE := 40

## Brake force applied when stopping the vehicle.
const BRAKE_FORCE := 20

## Wheel nodes
@onready var back_right_wheel: VehicleWheel3D = $Wheel_Back_Right
@onready var back_left_wheel: VehicleWheel3D = $Wheel_Back_Left
@onready var front_right_wheel: VehicleWheel3D = $Wheel_Front_Right
@onready var front_left_wheel: VehicleWheel3D = $Wheel_Front_Left

## Reference to the escape menu.
@onready var esc_menu := $"../EscMenuLayer"

## Called when the node is ready.
func _ready() -> void:
	setup_wheels()

## Handles input for toggling the escape menu.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var is_menu_visible: bool = esc_menu.visible
		esc_menu.visible = not is_menu_visible

		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE if esc_menu.visible else Input.MOUSE_MODE_CAPTURED
		)

## Called every physics frame to update vehicle behavior.
## @param delta: float - Frame time step.
func _physics_process(delta: float) -> void:
	handle_vehicle(delta)
	apply_forces()

## Reads player input and updates engine force, brake, and steering.
## @param delta: float - Frame time step.
func handle_vehicle(delta: float) -> void:
	var input_steering := Input.get_axis("move_right", "move_left")
	var input_forward := Input.is_action_pressed("move_forward")
	var input_back := Input.is_action_pressed("move_back")

	steering = move_toward(steering, input_steering * MAX_STEERING, delta * 0.25)

	engine_force = 0.0
	brake = 0.0

	if input_forward:
		engine_force = MAX_ENGINE_FORCE
	elif input_back:
		if linear_velocity.z > 1.0:
			brake = BRAKE_FORCE
		else:
			engine_force = -MAX_ENGINE_FORCE * 0.8

## Applies calculated forces to the wheels.
func apply_forces() -> void:
	back_left_wheel.engine_force = engine_force
	back_left_wheel.brake = brake
	back_right_wheel.engine_force = engine_force
	back_right_wheel.brake = brake

	front_left_wheel.steering = steering
	front_right_wheel.steering = steering

## Configures which wheels are used for traction and steering.
func setup_wheels() -> void:
	for wheel in [back_left_wheel, back_right_wheel, front_left_wheel, front_right_wheel]:
		wheel.use_as_traction = true

	front_left_wheel.use_as_steering = true
	front_right_wheel.use_as_steering = true
