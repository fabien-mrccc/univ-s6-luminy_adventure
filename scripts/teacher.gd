extends Node3D

@onready var _dialogue = get_node("../UI/dialogue")
var talking: bool = false 
var prompt: bool = false

func _on_interactable_focused(interactor: Interactor) -> void:
	if not prompt:
		_dialogue.display_line("", "appuyer sur E pour intéragir")
		prompt = true

func _on_interactable_interacted(interactor: Interactor) -> void:
	_dialogue.close()
	if not talking && not Global.answer:
		_dialogue.display_line("Teacher", "Bonjour, comment ça va ?")
		talking = true
	elif talking:
		_dialogue.close()
		talking = false
	if not talking && Global.answer:
		if Global.good_answer:
			_dialogue.display_line("Teacher", "bravo")
			talking = true
			Global.current_question += 1
			_reset()
		else:
			_dialogue.display_line("Teacher", "FAUX")
			talking = true
			Global.current_question += 1
			_reset()

func _on_interactable_unfocused(interactor: Interactor) -> void:
	if prompt:
		_dialogue.close()
		prompt = false

func _reset():
	Global.answer = false
	Global.good_answer = false
