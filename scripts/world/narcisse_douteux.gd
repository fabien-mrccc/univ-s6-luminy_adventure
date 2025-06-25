extends Node3D

## Indicates whether the "Press E" prompt is currently displayed.
var _prompt: bool = false

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../../UI/dialogue")
@onready var _curent = $"."
signal narcisse_found

## Called when an interactable is focused.
## Displays the "Press E" prompt if not already shown.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt:
		_dialogue.display_line("", "Appuyer sur E pour interagir.")
		_prompt = true
		
## Called when an interactable is unfocused.
## Closes the dialogue prompt if it is shown.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false
		
## Called when an interactable is interacted with.
## Adds the current narcisse to the global list if not already present,
## increments the global narcisse counter, and emits the narcisse_found signal.
func _on_interactable_interacted(interactor: Interactor) -> void:
	if _curent.get_meta("index") not in Global.narcisses:
		Global.narcisses.append(_curent.get_meta("index"))
		Global.current_botanic_narcisses += 1
		emit_signal("narcisse_found")
