extends VehicleBody3D

const MAX_STEERING := 0.2
const MAX_ENGINE_FORCE := 40
const BRAKE_FORCE := 20

@onready var back_right_wheel = $Wheel_Back_Right
@onready var back_left_wheel = $Wheel_Back_Left
@onready var front_right_wheel = $Wheel_Front_Right
@onready var front_left_wheel = $Wheel_Front_Left
@onready var esc_menu := $"../EscMenuLayer"

func _ready() -> void:
	setup_wheels()
	
## Handles toggling the escape menu and mouse mode.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var is_menu_visible: bool= esc_menu.visible

		esc_menu.visible = not is_menu_visible

		if esc_menu.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	handle_vehicle(delta)
	apply_forces()

func handle_vehicle(delta: float) -> void:
	var input_steering = Input.get_axis("move_right", "move_left")
	var input_forward = Input.is_action_pressed("move_forward")
	var input_back = Input.is_action_pressed("move_back")
	
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

func apply_forces():
	back_left_wheel.engine_force = engine_force
	back_left_wheel.brake = brake
	back_right_wheel.engine_force = engine_force
	back_right_wheel.brake = brake
	front_left_wheel.steering = steering
	front_right_wheel.steering = steering

func setup_wheels():
	back_left_wheel.use_as_traction = true
	back_right_wheel.use_as_traction = true
	front_left_wheel.use_as_traction = true
	front_right_wheel.use_as_traction = true
	front_left_wheel.use_as_steering = true
	front_right_wheel.use_as_steering = true
