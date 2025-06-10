extends Control
@onready var _name = $VBoxContainer/name
@onready var _question = $VBoxContainer/question
@onready var _prompt = $VBoxContainer/prompt

func display_line(speaker : String, line : String):
	_name.text = speaker
	_question.text = line
	open()
	
func open():
	visible = true
	
func close():
	visible = false	
