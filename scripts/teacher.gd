extends Node3D

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../UI/dialogue")

## References to question and answer nodes.
@onready var _question = $question
@onready var _answer1 = $answer1
@onready var _answer2 = $answer2
@onready var _answer3 = $answer3
@onready var _answer4 = $answer4
@onready var _player = $"../Player"

## Indicates if the NPC is currently talking.
var talking: bool = false

## Indicates if the interaction prompt ("press E") is shown.
var prompt: bool = false

## Indicates if the question has been shown already.
var question_shown: bool = false

## Shows a prompt message when the player focuses on the NPC if not already shown.
## @param interactor: Interactor - The player interacting.
func _on_interactable_focused(interactor: Interactor) -> void:
	if not prompt:
		_dialogue.display_line("", "appuyer sur E pour intéragir")
		prompt = true

## Handles interaction with the NPC, displaying questions and feedback.
## @param interactor: Interactor - The player interacting.
func _on_interactable_interacted(interactor: Interactor) -> void:
	_dialogue.close()

	if not question_shown:
		_next()
		_display_questions()
		question_shown = true
		

	if not talking and not Global.answer and not Global.qui_veut_reussir_son_annee_finished and not _player.save.qui_veut_reussir_son_annee:
		_dialogue.display_line("Professeur", "Bonjour, regarde le tableau")
		talking = true

	elif talking:
		_dialogue.close()
		talking = false

	elif not talking and Global.answer:
		if Global.good_answer:
			_dialogue.display_line("Professeur", "Bonne réponse")
			talking = true
			Global.current_question += 1
			if Global.current_question >= Global.answers.size():
				Global.qui_veut_reussir_son_annee_finished = true
			else:
				_next()
			_reset()
		else:
			_dialogue.display_line("Professeur", "Mauvaise réponse")
			talking = true
			Global.current_question += 1
			if Global.current_question >= Global.answers.size():
				Global.qui_veut_reussir_son_annee_finished = true
			else:
				_next()
			_reset()
	elif Global.qui_veut_reussir_son_annee_finished or _player.save.qui_veut_reussir_son_annee:
		_dialogue.display_line("Professeur", "Le quizz est finis")
		_player.save._valid_qui_veut_reussir_son_annee()
		_player._save()
		Global.current_question = Global.answers.size()
		Global.qui_veut_reussir_son_annee_finished = true

## Closes the prompt when the player stops focusing on the NPC.
## @param interactor: Interactor - The player moving away.
func _on_interactable_unfocused(interactor: Interactor) -> void:
	if prompt:
		_dialogue.close()
		prompt = false

## Resets the global answer state.
func _reset():
	Global.answer = false
	Global.good_answer = false

## Advances all question and answer nodes to the next question.
func _next():
	_question._next_question()
	_answer1._next_question()
	_answer2._next_question()
	_answer3._next_question()
	_answer4._next_question()

## Makes the question and answers visible.
func _display_questions():
	_question._display()
	_answer1._display()
	_answer2._display()
	_answer3._display()
	_answer4._display()
