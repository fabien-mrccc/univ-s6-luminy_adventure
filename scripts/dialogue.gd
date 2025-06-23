## Dialogue UI: displays the speaker's name and their line.
extends Control

## Reference to the text field for the speaker’s name.
@onready var _name = $VBoxContainer/name

## Reference to the text field containing the dialogue line (question or answer).
@onready var _question = $VBoxContainer/question

## Displays a line of dialogue with the speaker’s name and content.
## @param speaker: String - Name of the character speaking.
## @param line: String - Dialogue text to display.
func display_line(speaker: String, line: String):
	_name.text = speaker
	_question.text = line
	open()

## Makes the dialogue UI visible.
func open():
	visible = true

## Hides the dialogue UI.
func close():
	visible = false
