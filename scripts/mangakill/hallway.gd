extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	_enter_hallway()

## Displays the hallway introduction dialogue.
## Connects the next step to the scene start.
func _enter_hallway():
	dialogue_box.show_dialogue("Tu sors de la chambre et tu te retrouve dans le couloir.", ["Suivant"])
	dialogue_box.choice_selected.connect(start_scene)

## Starts the main hallway scene.
## Presents the player with two choices.
func start_scene(index: int) -> void:
	dialogue_box.show_dialogue(
		"Ren, assis dos au mur, griffonne des symboles sur le sol.",
		["Parler à Ren", "Découvrir la prochaine pièce"]
	)
	dialogue_box.choice_selected.connect(_on_first_choice)

## Handles the player's first decision in the hallway.
## Either begins the Ren dialogue or transitions to the next room.
func _on_first_choice(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_first_choice)

	if index == 0:
		dialogue_box.show_dialogue(
			"« Qui es-tu ? »",
			["Suivant"]
		)
		dialogue_box.choice_selected.connect(_on_ren_intro_1)
	else:
		dialogue_box.choice_selected.connect(_go_to_bathroom)

## Continues Ren's introduction dialogue.
func _on_ren_intro_1(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_1)

	dialogue_box.show_dialogue(
		"Ren : « Le monde est une fiction. Je suis celui qui devait le terminer.\nMais l’histoire… m’a effacé. »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_2)

## Continues Ren's dialogue about Akira.
func _on_ren_intro_2(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_2)

	dialogue_box.show_dialogue(
		"« Akira… est mort ? »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_3)

## Continues Ren's backstory about Akira’s fate.
func _on_ren_intro_3(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_3)

	dialogue_box.show_dialogue(
		"Ren : « Il a lu ce qu’il ne devait pas lire. Il a vu la dernière page. »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_4)

## Questions Ren’s implication in the story.
func _on_ren_intro_4(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ren_intro_4)

	dialogue_box.show_dialogue(
		"« Tu insinues que c’est toi le tueur ? »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_ren_intro_5)

## Offers final branching choices for more dialogue or exiting.
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

## Handles the player's final dialogue choice with Ren.
## Responds with different lines depending on the selected question.
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

## Transitions from the hallway to the bathroom scene.
## Changes the scene using the main node reference.
func _go_to_bathroom(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_go_to_bathroom)
	var main = get_tree().root.get_node("Main")
	if main:
		main.change_scene("res://scenes/mangakill/bathroom.tscn")
	else:
		print("Main introuvable.")
