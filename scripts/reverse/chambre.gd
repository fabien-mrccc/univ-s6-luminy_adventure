extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	dialogue_box.show_dialogue("Test de dialogue", ["Choix A", "Choix B"])
	start_intro()

func start_intro():
	dialogue_box.show_dialogue(
		"Tu ouvres les yeux. Un lit. Un mur. Une tache de sang.",
		["Regarder autour", "Sortir tout de suite"])
	dialogue_box.choice_selected.connect(self._on_intro_choice)
func _on_intro_choice(index):
	match index:
		0:
			# Affiche le texte
			dialogue_box.show_dialogue("Une feuille déchirée traîne sous le lit. \"Je suis désolé, Akira...\"", ["Suivant"])
		1:
			# Affiche le texte
			dialogue_box.show_dialogue("Tu sors sans rien voir. Un frisson te traverse.", ["Suivant"])
			
	# Connecte le signal du bouton "Suivant"
	dialogue_box.connect("choice_selected", Callable(self, "_on_next_pressed"))
# La méthode qui sera appelée lorsque le joueur clique sur "Suivant"
func _on_next_pressed(index):
	if index == 0:  # Vérifie si c'est le bouton "Suivant"
		# Changer la scène vers "Couloir.tscn"
		get_tree().change_scene_to_file("res://scenes/reverse/couloir.tscn")
