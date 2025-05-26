extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	_enter_hallway()

func _enter_hallway():
	dialogue_box.show_dialogue("Tu sors de la chambre et tu te retrouve dans le couloir.", ["Suivant"])
	dialogue_box.choice_selected.connect(start_scene)

func start_scene(index: int) -> void:
	# Introduction avec les deux premiers choix
	dialogue_box.show_dialogue(
		"Ren, assis dos au mur, griffonne des symboles sur le sol.",
		["Parler à Ren", "Découvrir la prochaine pièce"]
	)
	dialogue_box.choice_selected.connect(_on_first_choice)

func _on_first_choice(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_first_choice)

	if index == 0:
		# Début de l'échange avec Ren
		dialogue_box.show_dialogue(
			"« Qui es-tu ? »",
			["Suivant"]
		)
		dialogue_box.choice_selected.connect(_on_ren_intro_1)
	else:
		# Aller à la salle de bain
		get_tree().change_scene_to_file("res://scenes/mangakill/bathroom.tscn")

func _on_ren_intro_1(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_1)

	dialogue_box.show_dialogue(
		"Ren : « Le monde est une fiction. Je suis celui qui devait le terminer.\nMais l’histoire… m’a effacé. »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_2)

func _on_ren_intro_2(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_2)

	dialogue_box.show_dialogue(
		"« Akira… est mort ? »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_3)

func _on_ren_intro_3(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_3)

	dialogue_box.show_dialogue(
		"Ren : « Il a lu ce qu’il ne devait pas lire. Il a vu la dernière page. »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_4)

func _on_ren_intro_4(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_4)

	dialogue_box.show_dialogue(
		"« Tu insinues que c’est toi le tueur ? »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_5)

func _on_ren_intro_5(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_5)

	dialogue_box.show_dialogue(
		"Ren (rire amer) : « Non. Je suis l’erreur dans le scénario.\nMais toi, tu es une correction. »",
		[
			"Lui poser des questions sur Akira",
			"Lui demander s’il est le tueur",
			"Quitter la conversation sans insister"
		]
	)
	dialogue_box.choice_selected.connect(_on_final_choice_with_ren)

func _on_final_choice_with_ren(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_final_choice_with_ren)

	match index:
		0:
			dialogue_box.show_dialogue(
				"Ren murmure : « Akira disait qu’un personnage avait pris le contrôle. Tu comprends ce que ça signifie ? »",
				["Suivant"]
			)
		1:
			dialogue_box.show_dialogue(
				"Ren hausse les épaules : « Le tueur ne saigne pas. Il dessine. »",
				["Suivant"]
			)
		2:
			dialogue_box.show_dialogue(
				"Tu t’éloignes. Derrière toi, il chuchote : « Ne laisse pas l’histoire t’écrire. »",
				["Suivant"]
			)

	dialogue_box.choice_selected.connect(_go_to_bathroom)

func _go_to_bathroom(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_go_to_bathroom)
	get_tree().change_scene_to_file("res://scenes/mangakill/bathroom.tscn")
