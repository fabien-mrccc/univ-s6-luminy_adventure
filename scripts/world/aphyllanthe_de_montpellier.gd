extends Node3D

## Indicates whether the "Press E" prompt is currently displayed.
var _prompt: bool = false

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../../UI/dialogue")
@onready var _curent = $"."
signal aphyllanthe_found

## Called when an interactable object gains focus.
## Displays the interaction prompt if not already shown.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt:
		_dialogue.display_line("", "Appuyer sur E pour interagir.")
		_prompt = true
		
## Called when an interactable object loses focus.
## Closes the interaction prompt if it was shown.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false
		
## Called when the interactable object is interacted with.
## Adds the current aphyllanthe to global list and increments count if not already found.
func _on_interactable_interacted(interactor: Interactor) -> void:
	if _curent.get_meta("index") not in Global.aphyllanthes:
		Global.aphyllanthes.append(_curent.get_meta("index"))
		Global.current_botanic_aphyllanthes += 1
		emit_signal("aphyllanthe_found")
