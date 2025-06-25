## Manages the main control room logic including student interactions, document display, and dialogue.
extends Node3D

## Path follow node for student bot movement.
@onready var bot_path_follow = $BotPath/BotPathFollow

## UI root buttons and controls.
@onready var ui = $CanvasLayer/Control/BackgroundButton
@onready var control_root = $CanvasLayer/Control
@onready var btn_accept = $CanvasLayer/Control/BackgroundButton/Accept
@onready var btn_refuse = $CanvasLayer/Control/BackgroundButton/Refuse

## Player node reference.
@onready var player = $Player

## Animation player for character.
@onready var animation_player = $Player/Head/Character_020/AnimationPlayer

## Dialogue bubble for displaying text.
@onready var dialogue_bubble = $CanvasLayer/Control/DialogueBubble

## List of student scene paths to be instantiated sequentially.
var student_scenes: Array = [
	"res://scenes/characters/controlroom/1.tscn",
	"res://scenes/characters/controlroom/2.tscn",
	"res://scenes/characters/controlroom/3.tscn",
	"res://scenes/characters/controlroom/4.tscn"
]

## List of associated document scene paths for each student.
var document_scenes: Array = [
	"res://scenes/controlroom/doc_per_student/1.tscn",
	"res://scenes/controlroom/doc_per_student/2.tscn",
	"res://scenes/controlroom/doc_per_student/3.tscn",
	"res://scenes/controlroom/doc_per_student/4.tscn"
]

## Index of the currently active student/document pair.
var current_index := 0

## Reference to the currently spawned student.
var current_student: Node3D = null

## Reference to the currently displayed document.
var current_document: Node = null

## Counter for incorrect player choices.
var error_count: int = 0

## Called when the node enters the scene tree.
## Initializes UI and spawns the first student.
func _ready() -> void:
	dialogue_bubble.visible = false
	player.can_move = false

	btn_accept.pressed.connect(_on_accept_pressed)
	btn_refuse.pressed.connect(_on_refuse_pressed)

	_set_ui_visible(false)
	_spawn_student()

## Spawns the next student and their associated document.
func _spawn_student() -> void:
	if is_instance_valid(current_student):
		if current_student.is_connected("interaction_complete", Callable(self, "_on_student_interaction_complete")):
			current_student.disconnect("interaction_complete", Callable(self, "_on_student_interaction_complete"))
		current_student.queue_free()

	if current_index >= student_scenes.size():
		if error_count == 0:
			player.save._valid_control_room()
			player._save()
			get_tree().change_scene_to_file("res://scenes/world.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/world.tscn")
		return

	var student_scene = load(student_scenes[current_index])
	current_student = student_scene.instantiate()

	if current_index < document_scenes.size():
		var doc_scene = load(document_scenes[current_index])
		if doc_scene:
			var doc_instance = doc_scene.instantiate()
			$CanvasLayer.add_child(doc_instance)
			current_document = doc_instance
			current_document.visible = false
		else:
			current_document = null
	else:
		current_document = null

	current_index += 1

	bot_path_follow.add_child(current_student)
	current_student.reset_state()
	current_student.start_walk()

	current_student.connect("arrived_at_guichet", Callable(self, "_on_student_arrived"))
	current_student.connect("interaction_complete", Callable(self, "_on_student_interaction_complete"))

	_set_ui_visible(false)

## Called when student arrives at the interaction point.
## Displays UI and relevant dialogue.
func _on_student_arrived() -> void:
	_set_ui_visible(true)
	player.can_look = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if current_document and is_instance_valid(current_document):
		current_document.visible = true
		dialogue_bubble.show_dialogue(current_document.dialogue_entrée)

## Handles logic when the "accept" button is pressed.
func _on_accept_pressed() -> void:
	if is_instance_valid(current_student):
		_set_ui_visible(false)
		player.can_look = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		current_student.continue_after_accept()

		if current_document:
			dialogue_bubble.show_dialogue(current_document.dialogue_accepté)
			current_document.visible = false
			if current_document.should_be_accepted == false:
				error_count += 1

## Handles logic when the "refuse" button is pressed.
func _on_refuse_pressed() -> void:
	if is_instance_valid(current_student):
		_set_ui_visible(false)
		player.can_look = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		current_student.go_back()

		if current_document:
			dialogue_bubble.show_dialogue(current_document.dialogue_refusé)
			current_document.visible = false
			if current_document.should_be_accepted == true:
				error_count += 1

## Handles completion of the current student interaction.
## Spawns the next student after a short delay.
func _on_student_interaction_complete() -> void:
	if current_student.is_connected("interaction_complete", Callable(self, "_on_student_interaction_complete")):
		current_student.disconnect("interaction_complete", Callable(self, "_on_student_interaction_complete"))

	if current_document:
		current_document.queue_free()
		current_document = null

	dialogue_bubble.clear_dialogue()
	await get_tree().create_timer(0.5).timeout
	_spawn_student()

## Enables or disables the UI and adjusts input behavior accordingly.
## @param value: bool - Whether to show or hide the UI.
func _set_ui_visible(value: bool) -> void:
	ui.visible = value
	control_root.mouse_filter = Control.MOUSE_FILTER_STOP if value else Control.MOUSE_FILTER_IGNORE
