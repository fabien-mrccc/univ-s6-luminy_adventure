extends Node3D

## Reference to the world UI node for updates.
@onready var _world_ui = $"../WorldUi"

## Reference to the dialogue UI system.
@onready var _dialogue_ui = $UI/dialogue

## Indicates if the interaction prompt is currently shown.
var _prompt_shown: bool = false

## Called when any Aphyllanthe Montpellier plant is found.
## Updates aphyllanthes UI counter.
func _on_aphyllanthe_found() -> void:
	_world_ui._update_aphyllanthes()

## Called when any Narcisse Doubt plant is found.
## Updates narcisse UI counter.
func _on_narcisse_found() -> void:
	_world_ui._update_narcisse()

## Called when any Ciste plant is found.
## Updates ciste UI counter.
func _on_ciste_found() -> void:
	_world_ui._update_ciste()

# Aphyllanthe Montpellier signals mapped to a single handler
func _on_aphyllanthe_de_montpellier_1_aphyllanthe_found(): _on_aphyllanthe_found()
func _on_aphyllanthe_de_montpellier_2_aphyllanthe_found(): _on_aphyllanthe_found()
func _on_aphyllanthe_de_montpellier_3_aphyllanthe_found(): _on_aphyllanthe_found()
func _on_aphyllanthe_de_montpellier_4_aphyllanthe_found(): _on_aphyllanthe_found()
func _on_aphyllanthe_de_montpellier_5_aphyllanthe_found(): _on_aphyllanthe_found()
func _on_aphyllanthe_de_montpellier_6_aphyllanthe_found(): _on_aphyllanthe_found()
func _on_aphyllanthe_de_montpellier_7_aphyllanthe_found(): _on_aphyllanthe_found()
func _on_aphyllanthe_de_montpellier_8_aphyllanthe_found(): _on_aphyllanthe_found()

# Narcisse Doubt signals mapped to a single handler
func _on_narcisse_douteux_1_narcisse_found(): _on_narcisse_found()
func _on_narcisse_douteux_2_narcisse_found(): _on_narcisse_found()
func _on_narcisse_douteux_3_narcisse_found(): _on_narcisse_found()

# Ciste signals mapped to a single handler
func _on_ciste_2_ciste_found(): _on_ciste_found()
func _on_ciste_3_ciste_found(): _on_ciste_found()
func _on_ciste_4_ciste_found(): _on_ciste_found()
func _on_ciste_5_ciste_found(): _on_ciste_found()
func _on_ciste_6_ciste_found(): _on_ciste_found()
func _on_ciste_7_ciste_found(): _on_ciste_found()
func _on_ciste_8_ciste_found(): _on_ciste_found()
func _on_ciste_9_ciste_found(): _on_ciste_found()
func _on_ciste_10_ciste_found(): _on_ciste_found()
func _on_ciste_11_ciste_found(): _on_ciste_found()

## Called when an interactable gains focus.
## Displays interaction prompt if not already shown.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt_shown:
		_dialogue_ui.display_line("", "Appuyer sur E pour interagir.")
		_prompt_shown = true

## Called when the interactable is interacted with.
## Changes scene to Batiste's game.
func _on_interactable_interacted(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/qui_veut_reussir_son_annee/qui_veut_reussir_son_annee.tscn")

## Called when the interactable loses focus.
## Closes the interaction prompt if shown.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt_shown:
		_dialogue_ui.close()
		_prompt_shown = false

## Changes scene to control room.
func _on_interactable_interacted_control_room(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/control_room/control_room.tscn")

## Changes scene to Luminy For Speed racing world.
func _on_interactable_interacted_car(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/luminy_for_speed/race_world.tscn")
