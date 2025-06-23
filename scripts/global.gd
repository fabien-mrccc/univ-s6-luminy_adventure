## Contains global quiz data: answer state, progress, and correct answers.
extends Node

## Indicates if an answer has been given for the current question.
var answer: bool = false

## Indicates if the given answer is correct.
var good_answer: bool = false

## Number of the current question being displayed.
var current_question: int = 0

## Array of correct answers, indexed by question number.
## Example: answers[0] corresponds to the correct answer for the first question.
var answers = [
	3, 3, 1, 2, 4
]
