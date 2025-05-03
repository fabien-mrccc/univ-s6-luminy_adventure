extends GutTest

## Preloaded player scene for instantiating in tests.
## Reference to the player node in the instantiated scene.
var player_scene = preload("res://scenes/player.tscn") 
var player_node

## Sets up the player scene and node before each test case.
## This function instantiates the player scene and sets up the player node reference.
func before_each():
	var instance = player_scene.instantiate()
	add_child(instance)
	await get_tree().process_frame
	player_node = instance.get_node("Player")

## Cleans up the player node after each test case.
## This function frees the player node after each test case execution.
func after_each():
	player_node.queue_free()

## Tests player movement when moving forward.
## Simulates pressing the "move_forward" input action and checks that the player moves forward.
func test_move_forward():
	Input.action_press("move_forward")
	await get_tree().process_frame

	var initial_position = player_node.global_position

	for i in range(20): 
		player_node.simulate_physics(0.1)
		await get_tree().process_frame

	var new_position = player_node.global_position

	assert_lt(new_position.z, initial_position.z, "The player should go forward")

	Input.action_release("move_forward")

## Tests player movement when moving backward.
## Simulates pressing the "move_back" input action and checks that the player moves backward.
func test_move_back():
	Input.action_press("move_back")
	await get_tree().process_frame

	var initial_position = player_node.global_position

	for i in range(20): 
		player_node.simulate_physics(0.1)
		await get_tree().process_frame

	var new_position = player_node.global_position

	assert_gt(new_position.z, initial_position.z, "The player should go backward")

	Input.action_release("move_back")

## Tests player movement when moving left.
## Simulates pressing the "move_left" input action and checks that the player moves left.
func test_move_left():
	Input.action_press("move_left")
	await get_tree().process_frame

	var initial_position = player_node.global_position

	for i in range(20): 
		player_node.simulate_physics(0.1)
		await get_tree().process_frame

	var new_position = player_node.global_position

	assert_lt(new_position.x, initial_position.x, "The player should go left")

	Input.action_release("move_left")

## Tests player movement when moving right.
## Simulates pressing the "move_right" input action and checks that the player moves right.
func test_move_right():
	Input.action_press("move_right")
	await get_tree().process_frame

	var initial_position = player_node.global_position

	for i in range(20): 
		player_node.simulate_physics(0.1)
		await get_tree().process_frame

	var new_position = player_node.global_position

	assert_gt(new_position.x, initial_position.x, "The player should go right")

	Input.action_release("move_right")

## Tests player sprint functionality.
## Simulates pressing the "move_forward" and "sprint" input actions and checks that the player accelerates.
func test_sprint():
	Input.action_press("move_forward")
	Input.action_press("sprint")
	await get_tree().process_frame

	var initial_speed = player_node.velocity.length()
	var new_speed = player_node.velocity.length()

	for i in range(30): 
		player_node.simulate_physics(0.1)
		await get_tree().process_frame
		var current_speed = player_node.velocity.length()
		new_speed = current_speed if new_speed < current_speed else new_speed

	assert_gt(new_speed, initial_speed, "The player should sprint")

	Input.action_release("sprint")
	Input.action_release("move_forward")
	
## Tests player jump functionality.
## Simulates pressing the "jump" input action and checks that the player jumps upwards.
func test_jump():
	var min_position_y = player_node.global_position.y
	var max_position_y = min_position_y

	Input.action_press("jump")
	await get_tree().process_frame

	for i in range(100):
		player_node.simulate_physics(1 / 60.0)
		await get_tree().process_frame
		var current_position_y = player_node.global_position.y
		max_position_y = max(max_position_y, current_position_y)

	assert_gt(max_position_y, min_position_y, "The player should jump")

	Input.action_release("jump")
