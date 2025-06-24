extends Node3D

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../UI/dialogue")

## Indicates if the interaction prompt ("press E") is shown.
var prompt: bool = false

func _on_interactable_focused(interactor: Interactor) -> void:
	if not prompt:
		_dialogue.display_line("", "appuyer sur E pour intéragir")
		prompt = true


func _on_interactable_interacted(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/mangakill/main.tscn")


func _on_interactable_unfocused(interactor: Interactor) -> void:
	if prompt:
		_dialogue.close()
		prompt = false
