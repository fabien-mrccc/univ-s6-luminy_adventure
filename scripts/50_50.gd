## Handles the behavior of an NPC offering a "50/50" type help to the player.
extends Node3D

## Reference to the UI dialogue system.
@onready var _dialogue = get_node("../UI/dialogue")

## Indicates if a dialogue is currently active.
var _talking: bool = false

## Indicates if the "Press E to interact" prompt has been shown.
var _prompt: bool = false

## Indicates if the 50/50 help has already been used.
var _50_50_used: bool = false

## Indicates if the initial explanation has been given.
var _explanation: bool = false

## Random number generator instance.
var _rng = RandomNumberGenerator.new()

## Last generated hint number.
var _hint = 0

## Array storing the two hints for the 50/50 help.
var _hints = [0, 0]

## Question number for which the help was used.
var _question_used: int = -1

## Displays the interaction prompt if it hasn’t been shown yet.
## @param interactor: Interactor - The interactor (player) approaching.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt:
		_dialogue.display_line("", "appuyer sur E pour intéragir")
		_prompt = true

## Handles the player interacting with the NPC, including the 50/50 help logic.
## @param interactor: Interactor - The interactor (player) interacting.
func _on_interactable_interacted(interactor: Interactor) -> void:
	_dialogue.close()
	
	if not _talking and Global.qui_veut_reussir_son_annee_finished:
		_dialogue.display_line("étudiant", "Le jeu est finis")
		
	elif _talking and Global.qui_veut_reussir_son_annee_finished:
		_dialogue.close()
		_talking = false
		
	elif not Global.qui_veut_reussir_son_annee_finished:
		
		if _talking:
			_dialogue.close()
			_talking = false
		
		elif not _talking and not _50_50_used and _explanation and Global.qui_veut_reussir_son_annee_finished != not Global.qui_veut_reussir_son_annee_finished:
			_gen_50_50()
			_dialogue.display_line("étudiant", "la réponse est soit " + str(_hints[0]) + " soit " + str(_hints[1]))
			_talking = true
			_50_50_used = true
			_question_used = Global.current_question

		elif not _talking and not _50_50_used and not _explanation:
			_dialogue.display_line("étudiant", "reparle moi si tu veut de l'aide mais je ne t'aiderai qu'une seule fois")
			_explanation = true
			_talking = true

		elif _50_50_used and _question_used == Global.current_question:
			_dialogue.display_line("étudiant", "la réponse est soit " + str(_hints[0]) + " soit " + str(_hints[1]))

		elif _50_50_used and _question_used != Global.current_question:
			_dialogue.display_line("étudiant", "je t'ai déjà aidé")
			_talking = true

## Closes the interaction prompt when the player moves away.
## @param interactor: Interactor - The interactor (player) moving away.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false

## Generates two answer choices where one is incorrect (the 50/50 help).
func _gen_50_50():
	_hint = _rng.randi_range(1, 4)
	while _hint == Global.answers[Global.current_question]:
		_hint = _rng.randi_range(1, 4)
	_hints[0] = _hint
	_hints[1] = Global.answers[Global.current_question]
