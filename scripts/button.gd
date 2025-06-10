extends Node3D

@onready var _dialogue = get_node("../UI/dialogue")
@onready var _button = $"."
var prompt: bool = false

func _on_interactable_focused(interactor: Interactor) -> void:
	if not prompt:
		_dialogue.display_line("", "appuyer sur E pour intéragir")
		prompt = true

func _on_interactable_interacted(interactor: Interactor) -> void:
	if Global.current_question >= Global.answers.size():
		_dialogue.display_line("boutton", "c'est finit")
	elif Global.current_question < Global.answers.size():
		if not Global.answer:
			Global.answer = true
			if Global.answers[Global.current_question] == _button.get_meta("id"):
				Global.good_answer = true
		else:
			_dialogue.display_line("boutton", "vous avez deja donner une réponse")
	

func _on_interactable_unfocused(interactor: Interactor) -> void:
	if prompt:
		_dialogue.close()
		prompt = false
