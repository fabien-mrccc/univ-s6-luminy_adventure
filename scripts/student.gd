extends Node3D

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../UI/dialogue")

## Indicates whether a dialogue is currently ongoing.
var _talking: bool = false

## Indicates whether the "Press E" prompt is currently displayed.
var _prompt: bool = false

## Indicates whether the "friend" help has been used.
var _friend_used: bool = false

## Indicates whether the initial explanation has been given.
var _explanation: bool = false

## The question number for which help was used.
var _question_used: int = -1

## Shows a prompt message when the player focuses on the NPC, if not already shown.
## @param interactor: Interactor - The player interacting.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt:
		_dialogue.display_line("", "appuyer sur E pour intéragir")
		_prompt = true

## Handles interaction with the NPC, providing help if conditions are met.
## @param interactor: Interactor - The player interacting.
func _on_interactable_interacted(interactor: Interactor) -> void:
	_dialogue.close()

	if not _talking and not _friend_used and _explanation:
		# Give the answer directly.
		_dialogue.display_line("étudiant", "Il me semble que la réponse est " + str(Global.answers[Global.current_question]))
		_talking = true
		_friend_used = true
		_question_used = Global.current_question

	elif not _talking and not _friend_used and not _explanation:
		# Provide an initial explanation that help can only be given once.
		_dialogue.display_line("étudiant", "reparle moi si tu veut de l'aide mais je ne t'aiderai qu'une seule fois")
		_explanation = true
		_talking = true

	elif _friend_used and Global.current_question == _question_used:
		# If help already used for the current question, repeat the answer.
		_dialogue.display_line("étudiant", "Il me semble que la réponse est " + str(Global.answers[Global.current_question]))

	elif _friend_used and Global.current_question != _question_used:
		# If help was used on a previous question, inform the player.
		_dialogue.display_line("étudiant", "je t'ai déjà aidé")
		_talking = true

	elif _talking:
		# Close dialogue if already talking.
		_dialogue.close()
		_talking = false

## Closes the prompt when the player stops focusing on the NPC.
## @param interactor: Interactor - The player moving away.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false
