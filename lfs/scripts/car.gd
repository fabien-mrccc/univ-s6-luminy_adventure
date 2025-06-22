extends VehicleBody3D

const MAX_STEERING := 0.2
const MAX_ENGINE_FORCE := 400
const BRAKE_FORCE := 150

@onready var back_right_wheel = $Wheel_Back_Right
@onready var back_left_wheel = $Wheel_Back_Left
@onready var front_right_wheel = $Wheel_Front_Right
@onready var front_left_wheel = $Wheel_Front_Left

func _ready() -> void:
	setup_wheels()

func _physics_process(delta: float) -> void:
	handle_vehicle(delta)
	apply_forces()

func handle_vehicle(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("move_right", "move_left") * MAX_STEERING, delta * 2.5)
	if Input.is_action_pressed("move_forward"):
		engine_force = MAX_ENGINE_FORCE
	else:
		engine_force = 0.0
	if Input.is_action_pressed("move_back"):
		if linear_velocity.z < -0.5:
			engine_force = 0.0
			brake = BRAKE_FORCE
		else:
			engine_force = -MAX_ENGINE_FORCE * 0.9
			brake = 0.0

func apply_forces():
	back_left_wheel.engine_force = engine_force
	back_left_wheel.brake = brake
	back_right_wheel.engine_force = engine_force
	back_right_wheel.brake = brake
	front_left_wheel.steering = steering
	front_left_wheel.steering = steering
	
func setup_wheels():
	back_left_wheel.use_as_traction = true
	back_right_wheel.use_as_traction = true
	front_left_wheel.use_as_traction = true
	front_right_wheel.use_as_traction = true
	front_left_wheel.use_as_steering = true
	front_right_wheel.use_as_steering = true
