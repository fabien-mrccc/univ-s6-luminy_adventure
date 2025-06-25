extends CanvasLayer

@onready var exit_button: Button = $Background/MainPanel/VBoxContainer/ExitCenterContainer/ExitHboxContainer/ExitButton
@onready var bu_button: Button = $Background/MainPanel/VBoxContainer/BUCenterContainer/BUHboxContainer/BUButton
@onready var crosshair_checkbox: CheckBox = $Background/MainPanel/VBoxContainer/CrosshairCenterContainer/CrosshairHBoxContainer/CrosshairCheckBox
@onready var grass_button: CheckBox = $Background/MainPanel/VBoxContainer/GrassCenterContainer/GrassHBoxContainer/GrassCheckBox
@onready var screen_mode_option: OptionButton = $Background/MainPanel/VBoxContainer/DisplayCenterContainer/DisplayHBoxContainer/DisplayOptionButton
@onready var sound_slider: HSlider = $Background/MainPanel/VBoxContainer/SoundHboxContainer/SoundHSlider
@onready var sensitivity_slider: HSlider = $Background/MainPanel/VBoxContainer/SensitivityHBoxContainer/SensitivityHSlider

var player: Node
var crosshair_layer: CanvasLayer
var grass_multimesh: Node3D
var last_window_mode: int = -1

func _ready() -> void:
	exit_button.pressed.connect(_on_exit_pressed)
	bu_button.pressed.connect(_on_bu_pressed)
	crosshair_checkbox.toggled.connect(_on_crosshair_toggled)
	grass_button.toggled.connect(_on_grass_toggled)
	screen_mode_option.item_selected.connect(_on_screen_mode_selected)
	sound_slider.value_changed.connect(_on_sound_changed)
	sensitivity_slider.value_changed.connect(_on_sensitivity_changed)

	if get_tree().current_scene.has_node("Player"):
		player = get_tree().current_scene.get_node("Player")
		
	if get_parent().has_node("CrosshairLayer"):
		crosshair_layer = get_parent().get_node("CrosshairLayer")

	var world := get_tree().current_scene
	if world.has_node("Map/GrassMultiMeshes"):
		grass_multimesh = world.get_node("Map/GrassMultiMeshes")
	else:
		grass_multimesh = null

	last_window_mode = DisplayServer.window_get_mode()
	match last_window_mode:
		DisplayServer.WINDOW_MODE_WINDOWED:
			screen_mode_option.select(0)
		_:
			screen_mode_option.select(1)
			
	AudioServer.set_bus_volume_db(0, linear_to_db(sound_slider.value))

func _process(_delta: float) -> void:
	var current_mode = DisplayServer.window_get_mode()
	if current_mode != last_window_mode:
		last_window_mode = current_mode
		match current_mode:
			DisplayServer.WINDOW_MODE_WINDOWED:
				screen_mode_option.select(0)
			DisplayServer.WINDOW_MODE_FULLSCREEN:
				screen_mode_option.select(1)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_bu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_crosshair_toggled(checked: bool) -> void:
	if crosshair_layer:
		crosshair_layer.visible = checked

func _on_grass_toggled(visible: bool) -> void:
	if grass_multimesh:
		grass_multimesh.visible = visible
	else:
		push_warning("No GrassMultiMeshes node.")

func _on_screen_mode_selected(index: int) -> void:
	DisplayServer.window_set_size(Vector2i(1920, 1080))

	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			center_window_on_screen()
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			center_window_on_screen()

func center_window_on_screen() -> void:
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_size: Vector2i = DisplayServer.window_get_size()
	var centered_pos: Vector2i = (screen_size - window_size) / 2
	DisplayServer.window_set_position(centered_pos)

func _on_sound_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_sensitivity_changed(value: float) -> void:
	if player:
		player.sensitivity = value
