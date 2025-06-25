## Displays and clears dialogue text on a label.
extends Label

## Shows the given dialogue text and makes the label visible.
## @param new_text: String - The dialogue text to display.
func show_dialogue(new_text: String) -> void:
	text = new_text
	visible = true

## Clears the dialogue text and hides the label.
func clear_dialogue() -> void:
	text = ""
	visible = false
