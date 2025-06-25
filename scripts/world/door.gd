extends Node3D

## Reference to the UI dialogue system.
@onready var _dialogue = get_node("../UI/dialogue")

## Indicates if the "Press E to interact" prompt has been shown.
var _prompt: bool = false

## Called when an interactable gains focus.
## Displays the interaction prompt if not already shown.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt:
		_dialogue.display_line("", "Appuyer sur E pour interagir.")
		_prompt = true

## Called when an interactable is interacted with.
## Changes scene to the main world scene.
func _on_interactable_interacted(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

## Called when an interactable loses focus.
## Closes the interaction prompt if it was shown.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false
