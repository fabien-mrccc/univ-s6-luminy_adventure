## Contains global quiz data: answer state, progress, and correct answers.
extends Node

## Indicates if an answer has been given for the current question.
var answer: bool = false

## Indicates if the given answer is correct.
var good_answer: bool = false

## Number of the current question being displayed.
var current_question: int = 0

#var qui_veut_reussir_son_annee_finished:bool = false
var manga_kill_finished:bool = false

var wrong_answer:bool = false

var lfs:bool = false

## Array of correct answers, indexed by question number.
## Example: answers[0] corresponds to the correct answer for the first question.
var answers = [
	3, 3, 1, 2, 4
]

var cistes = []
var aphyllanthes = []
var narcisses = []

var total_ciste = 10
var current_ciste = 0

var total_botanic_aphyllanthes = 8
var current_botanic_aphyllanthes = 0

var total_botanic_narcisses = 3
var current_botanic_narcisses = 0
