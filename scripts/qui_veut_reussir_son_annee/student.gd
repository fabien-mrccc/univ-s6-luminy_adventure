extends Node3D

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../UI/dialogue")
@onready var _player = $"../Player"

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
		_dialogue.display_line("", "Appuyer sur E pour interagir.")
		_prompt = true

## Handles interaction with the NPC, providing help if conditions are met.
## @param interactor: Interactor - The player interacting.
func _on_interactable_interacted(interactor: Interactor) -> void:
	_dialogue.close()
	
	if _player.save.qui_veut_reussir_son_annee:
		_dialogue.display_line("étudiant", "Le jeu est fini.")
		
	elif _talking and _player.save.qui_veut_reussir_son_annee:
		_dialogue.close()
		_talking = false
	
	elif not _player.save.qui_veut_reussir_son_annee:
		
		if _talking:
			_dialogue.close()
			_talking = false
		
		elif not _talking and not _friend_used and not _explanation:
			_dialogue.display_line("étudiant", "Reparle-moi si tu veux de l'aide mais je ne t'aiderai qu'une seule fois.")
			_explanation = true
			_talking = true
		
		elif not _talking and not _friend_used and _explanation and Global.current_question < 5:
			_dialogue.display_line("étudiant", "Il me semble que la réponse est " + str(Global.answers[Global.current_question]) + ".")
			_talking = true
			_friend_used = true
			_question_used = Global.current_question

		elif _friend_used and Global.current_question == _question_used:
			_dialogue.display_line("étudiant", "Il me semble que la réponse est " + str(Global.answers[Global.current_question]) + ".")

		elif _friend_used and Global.current_question != _question_used:
			_dialogue.display_line("étudiant", "Je t'ai déjà aidé.")
			_talking = true

## Closes the prompt when the player stops focusing on the NPC.
## @param interactor: Interactor - The player moving away.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false
