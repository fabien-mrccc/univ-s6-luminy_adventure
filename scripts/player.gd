## Controls the player character's movement and camera behavior.
extends CharacterBody3D

var save_file_path = "user://save/"
var save_file_name = "Save_test.tres"
var save = Save.new()

## Movement speed in walk mode.
const WALK_SPEED := 4.0

## Movement speed in sprint mode.
const SPRINT_SPEED := 50.0

## Default camera field of view (FOV).
const BASE_FOV := 90.0

## Camera offset for walk animation.
const WALK_OFFSET := 0.1

## Acceleration due to gravity.
const GRAVITY := 9.8

## Current horizontal movement speed.
var _speed: float = WALK_SPEED

## Flag indicating whether sprinting is active.
var is_sprinting := false

## Flags to enable/disable movement and camera control
var can_move := true
var can_look := true

## Camera base position and interpolated target position.
var base_camera_pos: Vector3
var camera_target_pos: Vector3

<<<<<<< HEAD
## Player movement controls.
var movement_enabled := true 
var camera_enabled := true
=======
## Mouse sensitivity for looking around.
@export var sensitivity: float = 40

## Mouse sensitivity offset.
const SENSITIVITY_OFFSET := 10000
>>>>>>> 6dbcc20d0274591875d765bcbc8877f7756aed54

## Node references.
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var animation_player: AnimationPlayer = $Head/Character_020/AnimationPlayer
@onready var shader_material: ShaderMaterial = $MotionLinesLayer/MotionLines.material
@onready var _worldUi = $"../WorldUi"

## Called when the node enters the scene tree.
## Captures the mouse and initializes the camera FOV and positions.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = BASE_FOV
	base_camera_pos = camera.position
	camera_target_pos = base_camera_pos
	_play_animation("Idle")
	_verify_save_directory(save_file_path)
	if ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		save = ResourceLoader.load( save_file_path + save_file_name )
		Global.qui_veut_reussir_son_annee_finished = true
	_update()
		
func _verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	
func _load_data():
	save = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	print("loaded")
	
func _save():
	ResourceSaver.save(save, save_file_path + save_file_name)
	print(save)

func _update():
	if get_tree().current_scene.name == "game_batiste":
		_worldUi._update_qui_veut_reussir_son_annee()
	else:
		_worldUi._update_qui_veut_reussir_son_annee()
		_worldUi._update_aphyllanthes()
		_worldUi._update_ciste()
		_worldUi._update_narcisse()
		_worldUi._update_qui_veut_reussir_son_annee()
		_worldUi._update_luminy_for_speed()
		_worldUi._update_control_room()
		_worldUi._update_manga_kill()

## Handles mouse motion for camera and head rotation.
## @param event: InputEventMouseMotion - Mouse motion event.
func _unhandled_input(event: InputEvent) -> void:
<<<<<<< HEAD
	if not camera_enabled:
		return  
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
=======
	if can_look and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity / SENSITIVITY_OFFSET)
		camera.rotate_x(-event.relative.y * sensitivity / SENSITIVITY_OFFSET)
>>>>>>> 6dbcc20d0274591875d765bcbc8877f7756aed54
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
## Handles toggling the escape menu and mouse mode.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		var esc_menu := $EscMenuLayer
		var is_menu_visible: bool= esc_menu.visible

		esc_menu.visible = not is_menu_visible

		if esc_menu.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			can_move = false
			can_look = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			can_move = true
			can_look = true

## Applies movement, gravity, smooth camera update and FOV update each frame.
## @param delta: float - Frame time.
func _physics_process(delta: float) -> void:
<<<<<<< HEAD
	if movement_enabled:
		_handle_movement_input(delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 10.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 10.0)
	
	camera.position = camera.position.lerp(camera_target_pos, delta * 10.0)
	_apply_gravity(delta)
=======
	if not can_move:
		return
		
	_apply_gravity(delta)
	_handle_movement_input(delta)

	var previous_position: Vector3 = global_position

>>>>>>> 6dbcc20d0274591875d765bcbc8877f7756aed54
	move_and_slide()

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var is_moving := input_dir.length_squared() > 0.001
	var movement_delta: Vector3 = global_position - previous_position
	movement_delta.y = 0.0 

	if is_moving and is_on_floor() and movement_delta.length_squared() < 0.0001:
		global_position.y += 0.05

	camera.position = camera.position.lerp(camera_target_pos, delta * 10.0)

## Applies gravity to the player when airborne.
## @param delta: float - Frame time.
func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= GRAVITY * delta

## Updates horizontal movement input, speed, animations, and shader parameters.
## @param delta: float - Frame time.
func _handle_movement_input(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var is_moving := input_dir.length_squared() > 0.001
	is_sprinting = Input.is_action_pressed("sprint")

	if is_sprinting and is_moving:
		_set_speed_and_anim(SPRINT_SPEED, "Run", true)
		camera_target_pos = base_camera_pos - Vector3(0, 0, WALK_OFFSET)
	elif is_moving:
		_set_speed_and_anim(WALK_SPEED, "Walk", false)
		camera_target_pos = base_camera_pos - Vector3(0, 0, WALK_OFFSET)
	else:
		_set_speed_and_anim(WALK_SPEED, "Idle", false)
		camera_target_pos = base_camera_pos

	var direction := (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var accel := 7.0 if is_on_floor() else 3.0
	velocity.x = lerp(velocity.x, direction.x * _speed, delta * accel)
	velocity.z = lerp(velocity.z, direction.z * _speed, delta * accel)

## Sets movement speed, animation, and sprint shader parameter.
## @param speed: float - Movement speed to apply.
## @param anim_name: String - Animation name to play.
## @param sprint_active: bool - Whether sprint is active for shader effect.
func _set_speed_and_anim(speed: float, anim_name: String, sprint_active: bool) -> void:
	_speed = speed
	shader_material.set_shader_parameter("sprint_active", int(sprint_active))
	_play_animation(anim_name)

## Plays the specified animation only if not already playing.
## @param name: String - Animation name to play.
func _play_animation(name: String) -> void:
	if animation_player.current_animation != name:
		animation_player.play(name, 0.3)

## Simulates a single physics step. Useful for unit testing.
## @param delta: float - Frame time.
func simulate_physics(delta: float) -> void:
	_physics_process(delta)
