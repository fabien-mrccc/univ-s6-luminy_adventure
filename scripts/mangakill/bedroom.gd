extends Node2D

@onready var dialogue_box: Control = $Dialogue
@onready var note: Sprite2D = $Note
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
				note.show()
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
	var note_image = load("res://assets/mangakill/note.png")
	var main = get_tree().root.get_node("Main")
	if main:
		main.add_clue(note_image)
	else:
		print("Main introuvable.")
	dialogue_box.show_dialogue("Tu ranges la page. Elle pourrait être importante.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_go_to_hallway)

func _on_go_to_hallway(index: int) -> void:
	var main = get_tree().root.get_node("Main")
	if main:
		main.change_scene("res://scenes/mangakill/hallway.tscn")
	else:
		print("Main introuvable.")
