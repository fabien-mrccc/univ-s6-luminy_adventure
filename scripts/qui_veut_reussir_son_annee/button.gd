## Manages the behavior of a quiz answer button (buzzer) in the 3D interface.
extends Node3D

## Reference to the UI dialogue system.
@onready var _dialogue = get_node("../UI/dialogue")

## Reference to this button node (used to access its metadata).
@onready var _button = $"."

## Reference to the buzzer animation (animated button).
@onready var _anim = $Button/Buzzer_000/AnimationPlayer

## Indicates if the "Press E" prompt has already been shown.
var prompt: bool = false

## Displays an interaction prompt when the player approaches the button.
## @param interactor: Interactor - The interactor (player) approaching.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not prompt:
		_dialogue.display_line("", "appuyer sur E pour interagir")
		prompt = true

## Handles behavior when interacting with the button.
## Plays the animation, checks the answer, and shows a message if already answered or quiz finished.
## @param interactor: Interactor - The interactor (player) interacting.
func _on_interactable_interacted(interactor: Interactor) -> void:
	_anim.play("Pressed")

	if Global.current_question >= Global.answers.size():
		_dialogue.display_line("bouton", "Le quiz est fini")

	elif Global.current_question < Global.answers.size():
		if not Global.answer:
			Global.answer = true
			if Global.answers[Global.current_question] == _button.get_meta("id"):
				Global.good_answer = true
		else:
			_dialogue.display_line("bouton", "vous avez déjà donné une réponse")

## Closes the interaction prompt when the player moves away from the button.
## @param interactor: Interactor - The interactor (player) moving away.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if prompt:
		_dialogue.close()
		prompt = false
