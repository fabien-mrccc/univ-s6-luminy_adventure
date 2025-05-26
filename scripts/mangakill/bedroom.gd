extends Node2D

@onready var dialogue_box: Control = $Dialogue
var story_step := 0

func _ready():
	start_intro()

func start_intro():
	dialogue_box.show_dialogue(
		"Tu te réveilles dans un lit froid. Les murs te semblent familiers. Pourtant… tu n’es jamais venu ici.",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_intro_step)

func _on_intro_step(index: int) -> void:
	if story_step == 0:
		story_step += 1
		dialogue_box.show_dialogue(
			"Sur le plafond, quelqu’un a gravé un mot avec ses ongles : ‘RÉVEILLE-TOI’\nEt toujours, ce nom… Akira.",
			["Regarder autour de soi", "Sortir tout de suite"]
		)
	else:
		match index:
			0:
				# Choix 0 : Regarder autour
				dialogue_box.show_dialogue(
					"Sous le lit, une page déchirée, tachée d’encre :\n\n\"Akira savait. Il m’avait prévenu. Trop tard.\"",
					["Prendre l’indice"]
				)
				dialogue_box.choice_selected.connect(_on_take_hint)
			1:
				# Choix 1 : Sortir tout de suite
				dialogue_box.show_dialogue(
					"Tu quittes la pièce. Mais tu sens que quelque chose t’observe encore.",
					["Suivant"]
				)
				dialogue_box.choice_selected.connect(_on_go_to_hallway)
				
func _on_take_hint(index: int) -> void:
	Clues.add_clue("Akira savait. Il m’avait prévenu. Trop tard.")
	dialogue_box.show_dialogue("Tu ranges la page. Elle pourrait être importante.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_go_to_hallway)

func _on_go_to_hallway(index: int) -> void:
	# Transition vers le couloir (à personnaliser selon ta scène suivante)
	get_tree().change_scene_to_file("res://scenes/mangakill/hallway.tscn")
