extends Node3D

## Reference to the dialogue UI system.
@onready var _dialogue = get_node("../UI/dialogue")

var save_file_path = "user://save/"
var save_file_name = "Save_test.tres"
var save = Save.new()

## References to question and answer nodes.
@onready var _question = $question
@onready var _answer1 = $answer1
@onready var _answer2 = $answer2
@onready var _answer3 = $answer3
@onready var _answer4 = $answer4

## Indicates if the NPC is currently talking.
var talking: bool = false

## Indicates if the game is finished.
var game_finished:bool = false
signal  game_finished_signal

## Indicates if the interaction prompt ("press E") is shown.
var prompt: bool = false

## Indicates if the question has been shown already.
var question_shown: bool = false

func _ready():
	_verify_save_directory(save_file_path)
	if ( ResourceLoader.exists( save_file_path + save_file_name ) ):
		save = ResourceLoader.load( save_file_path + save_file_name )
		
func _verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	
func _load_data():
	save = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	print("loaded")
	
func _save():
	ResourceSaver.save(save, save_file_path + save_file_name)
	print(save)

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
		

	if not talking and not Global.answer and not game_finished and not save.qui_veut_reussir_son_annee:
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
				game_finished = true
			else:
				_next()
			_reset()
		else:
			_dialogue.display_line("Professeur", "Mauvaise réponse")
			talking = true
			Global.current_question += 1
			if Global.current_question >= Global.answers.size():
				game_finished = true
			else:
				_next()
			_reset()
	elif game_finished or save.qui_veut_reussir_son_annee:
		_dialogue.display_line("Professeur", "Le quizz est finis")
		save._valid_qui_veut_reussir_son_annee()
		_save()
		Global.current_question = Global.answers.size()

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
