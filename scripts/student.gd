extends Node3D

@onready var _dialogue = get_node("../UI/dialogue")
var talking: bool = false 
var prompt: bool = false
var friend_used: bool = false
var explanation: bool = false

func _on_interactable_focused(interactor: Interactor) -> void:
	if not prompt:
		_dialogue.display_line("", "appuyer sur E pour intéragir")
		prompt = true

func _on_interactable_interacted(interactor: Interactor) -> void:
	_dialogue.close()
	if not talking && not friend_used && explanation:
		_dialogue.display_line("student", str(Global.answers[Global.current_question]))
		talking = true
		friend_used = true
	elif not talking && not friend_used && not explanation:
		_dialogue.display_line("student", "reparle moi si tu veut de l'aide mais je ne t'aiderai qu'une seule fois")
		explanation = true
		talking = true
	elif friend_used:
		_dialogue.display_line("student","je t'ai deja aider")
		talking = true
	elif talking:
		_dialogue.close()
		talking = false

func _on_interactable_unfocused(interactor: Interactor) -> void:
	if prompt:
		_dialogue.close()
		prompt = false

func _reset():
	Global.answer = false
	Global.good_answer = false
