extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	# Affiche le premier dialogue avec les choix
	dialogue_box.show_dialogue("Ren est assis au sol, les yeux fermés.",
		["Lui poser des questions sur Akira", "Lui demander s’il est le tueur", "Quitter la conversation sans insister"])
	dialogue_box.choice_selected.connect(_on_choice_selected)

func _on_choice_selected(index):
	match index:
		0:
			dialogue_box.show_dialogue("Ren : \"Akira était trop prévisible. Il a payé le prix d'une intrigue faible.\"", ["Suivant"])
		1:
			dialogue_box.show_dialogue("Ren rit : \"Le coupable est dans l’histoire.\"", ["Suivant"])
		2:
			dialogue_box.show_dialogue("Ren murmure : \"Même l’auteur ne peut plus réécrire la fin...\"", ["Suivant"])

	# Connecte le bouton "Suivant" pour avancer
	dialogue_box.connect("choice_selected", Callable(self, "_on_next_pressed"))

# Méthode pour gérer l'appui sur le bouton "Suivant"
func _on_next_pressed(index):
	# Si l'utilisateur appuie sur le bouton "Suivant" (index == 0)
	dialogue_box.disconnect("choice_selected", Callable(self, "_on_next_pressed"))
	
	# Affiche les options de navigation
	dialogue_box.show_dialogue("Où veux-tu aller ?", ["Aller au salon", "Aller à la salle de bain", "Aller à la bibliothèque"])
	dialogue_box.choice_selected.connect(_on_navigation_selected)

func _on_navigation_selected(index):
	match index:
		0:
			get_tree().change_scene_to_file("res://scenes/reverse/salon.tscn")
		1:
			get_tree().change_scene_to_file("res://scenes/reverse/salle_de_bain.tscn")
		2:
			get_tree().change_scene_to_file("res://scenes/reverse/bibliothèque.tscn")
