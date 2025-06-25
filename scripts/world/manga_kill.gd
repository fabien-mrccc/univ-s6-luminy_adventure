extends Node3D

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../UI/dialogue")

## Indicates if the interaction prompt ("press E") is shown.
var prompt: bool = false

## Called when an interactable gains focus.
## Displays the interaction prompt if not already shown.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not prompt:
		_dialogue.display_line("", "Appuyer sur E pour interagir.")
		prompt = true

## Called when the interactable is interacted with.
## Changes the scene to the manga kill main scene.
func _on_interactable_interacted(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/mangakill/main.tscn")

## Called when the interactable loses focus.
## Closes the interaction prompt if it was shown.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if prompt:
		_dialogue.close()
		prompt = false
