extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	dialogue_box.show_dialogue(
		"Un miroir brisé. L'eau est rouge. Quelque chose brille dans le lavabo.",
		["Inspecter le miroir", "Récupérer l'objet dans le lavabo", "Sortir sans rien prendre"]
	)
	dialogue_box.choice_selected.connect(_on_choice_selected)

func _on_choice_selected(index):
	dialogue_box.choice_selected.disconnect(_on_choice_selected)

	match index:
		0:
			dialogue_box.show_dialogue("Tu te vois… mais ton reflet sourit. Ce n’est pas toi.", ["Suivant"])
		1:
			dialogue_box.show_dialogue("Tu obtiens la clé et vois le bracelet avec l’initiale \"S\".", ["Suivant"])
		2:
			dialogue_box.show_dialogue("Tu rates un indice crucial pour la suite.", ["Suivant"])

	dialogue_box.choice_selected.connect(_on_next_pressed)

func _on_next_pressed(index):
	if index == 0:
		dialogue_box.choice_selected.disconnect(_on_next_pressed)
		get_tree().change_scene_to_file("res://scenes/reverse/couloir.tscn")
