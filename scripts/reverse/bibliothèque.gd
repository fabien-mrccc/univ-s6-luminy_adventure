extends Node2D

@onready var dialogue_box: Control = $Dialogue

var phase := 0

func _ready():
	dialogue_box.show_dialogue("Suzu est agenouillée, cherchant un livre.",
		["Parler du bracelet", "Lui demander si elle ment", "Ne rien dire et observer"])
	dialogue_box.choice_selected.connect(_on_suzu_choice)

func _on_suzu_choice(index):
	dialogue_box.choice_selected.disconnect(_on_suzu_choice)

	match index:
		0:
			dialogue_box.show_dialogue("Suzu devient nerveuse : \"Je l’ai perdu… pas ici… enfin, je crois...\"", ["Suivant"])
		1:
			dialogue_box.show_dialogue("Elle s'énerve et quitte la pièce.", ["Suivant"])
		2:
			dialogue_box.show_dialogue("Elle soupire, prend un livre, et s'en va sans un mot.", ["Suivant"])

	dialogue_box.choice_selected.connect(_on_next_to_mika)

func _on_next_to_mika(index):
	if index == 0:
		dialogue_box.choice_selected.disconnect(_on_next_to_mika)
		_mika_sequence()

func _mika_sequence():
	dialogue_box.show_dialogue(
		"Mika entre calmement. \"Ce manga se réécrit sous nos yeux.\"",
		["Lui demander si c'est elle", "Lire par-dessus son épaule", "Utiliser la clé pour ouvrir le tiroir"])
	dialogue_box.choice_selected.connect(_on_mika_choice)

func _on_mika_choice(index):
	dialogue_box.choice_selected.disconnect(_on_mika_choice)

	match index:
		0:
			dialogue_box.show_dialogue("Elle sourit étrangement.", ["Suivant"])
		1:
			dialogue_box.show_dialogue("Le texte change en fonction de tes décisions passées.", ["Suivant"])
		2:
			dialogue_box.show_dialogue("Tu trouves un carnet : \"Quelqu’un manipule les pages... Mika regarde, mais comprend-elle ?\"", ["Suivant"])

	# Ajoute un bouton "Suivant"
	dialogue_box.choice_selected.connect(_on_next_to_couloir)

func _on_next_to_couloir(index):
	if index == 0:
		dialogue_box.choice_selected.disconnect(_on_next_to_couloir)
		get_tree().change_scene_to_file("res://scenes/reverse/couloir.tscn")
