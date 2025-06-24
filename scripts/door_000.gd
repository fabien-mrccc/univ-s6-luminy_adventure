extends Node3D

## Reference to the UI dialogue system.
@onready var _dialogue = get_node("../UI/dialogue")

## Indicates if the "Press E to interact" prompt has been shown.
var _prompt: bool = false

func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt:
		_dialogue.display_line("", "appuyer sur E pour interagir")
		_prompt = true


func _on_interactable_interacted(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false
