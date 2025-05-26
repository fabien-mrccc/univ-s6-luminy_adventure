extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	start_scene()

func start_scene():
	# Étape 1 : entrée dans la salle de bain
	dialogue_box.show_dialogue("Tu entres dans la salle de bain.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_entered)

func _on_entered(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_entered)
	dialogue_box.show_dialogue("L’endroit est anormalement silencieux.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_silence)

func _on_silence(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_silence)
	dialogue_box.show_dialogue(
		"Le miroir est fissuré. Il tremble légèrement… comme s’il respirait.\nL’eau du lavabo est trouble, rougeâtre. Quelque chose y repose.",
		["Inspecter le miroir", "Récupérer l’objet dans le lavabo", "Sortir sans rien prendre"]
	)
	dialogue_box.choice_selected.connect(_on_bathroom_choice)

func _on_bathroom_choice(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_bathroom_choice)

	match index:
		0:
			dialogue_box.show_dialogue(
				"Ton reflet te regarde… et cligne des yeux en décalé. Il n'est pas toi.",
				["Découvrir la pièce suivante"]
			)
			dialogue_box.choice_selected.connect(_go_to_livingroom)
		1:
			dialogue_box.show_dialogue(
				"Tu obtiens la clé. Derrière le lavabo, le bracelet. Initiale : S\nIl est cassé.",
				["Prendre l'indice"]
			)
			dialogue_box.choice_selected.connect(_on_take_hint)

		2:
			dialogue_box.show_dialogue(
				"Un murmure monte derrière toi :\n« Tu n’as plus de reflet. »",
				["Découvrir la pièce suivante"]
			)
			dialogue_box.choice_selected.connect(_go_to_livingroom)



func _on_take_hint(index: int) -> void:
	Clues.add_clue("Clé")
	Clues.add_clue("Bracelet cassé avec initial S")
	dialogue_box.show_dialogue("Tu prends la clé et le bracelet et tu sors de la salle de bain", ["Découvrir la pièce suivante"])
	dialogue_box.choice_selected.connect(_go_to_livingroom)
	
func _go_to_livingroom(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_go_to_livingroom)
	get_tree().change_scene_to_file("res://scenes/mangakill/livingroom.tscn")
