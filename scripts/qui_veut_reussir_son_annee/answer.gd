## Represents a 3D displayed answer for a quiz question.
extends Label3D

## Reference to the Label3D node that contains the answer text.
@onready var _answer = $"."

## Array containing all possible answers, indexed by question.
var answers = [
	"Où se situe le campus de Luminy?", "Quel parc naturel entoure le campus de Luminy?", "Quelle célèbre calanque est accessible à pied depuis le campus?", "En quelle année est le domaine Luminy mentionné pour la première fois?", "que ce trouve sur le domaine de Luminy?",
	"Aix-en-Provence", "Parc national du Mercantour", "Sugiton", "1710", "un phare",
	"Avignon", "Parc naturel régional de Camargue", "En-Vau", "1005", "une chapelle",
	"Marseille", "Parc national des Calanques", "Port-Miou", "1532", "un fort",
	"Toulon", "Parc naturel régional du Luberon", "Morgiou", "512", "une bastide"
]

## Updates the displayed answer text based on the current question.
func _next_question():
	if _answer.get_meta("index") == 0:
		_answer.text = answers[Global.current_question + _answer.get_meta("index")]
	elif Global.current_question + _answer.get_meta("index") < 25:
		_answer.text = str(_answer.get_meta("index")/5) + ") " + answers[Global.current_question + _answer.get_meta("index")]

## Makes the label visible on screen.
func _display():
	visible = true
