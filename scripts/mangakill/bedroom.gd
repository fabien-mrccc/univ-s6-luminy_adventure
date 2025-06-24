extends Node2D

@onready var dialogue_box: Control = $Dialogue
@onready var note: Sprite2D = $Note
var story_step := 0

func _ready():
	start_intro()

## Called to start the introduction scene.
## Displays the initial wake-up dialogue and connects to the next step.
func start_intro():
	dialogue_box.show_dialogue(
		"Tu te réveilles dans un lit froid. Les murs te semblent familiers. Pourtant… tu n’es jamais venu ici.",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_intro_step)

## Called after the intro dialogue progresses.
## Displays the next set of choices and handles the player’s decision.
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
				note.show()
				dialogue_box.show_dialogue(
					"Sous le lit, une page déchirée, tachée d’encre :\n\n\"Akira savait. Il m’avait prévenu. Trop tard.\"",
					["Prendre l’indice"]
				)
				dialogue_box.choice_selected.connect(_on_take_hint)
			1:
				dialogue_box.show_dialogue(
					"Tu quittes la pièce. Mais tu sens que quelque chose t’observe encore.",
					["Suivant"]
				)
				dialogue_box.choice_selected.connect(_on_go_to_hallway)
				
## Called when the player takes the note.
## Adds the note to the clues list and prepares for scene transition.
func _on_take_hint(index: int) -> void:
	var note_image = load("res://assets/mangakill/note.png")

	var main = get_tree().root.get_node("Main")
	if main:
		main.add_clue(note_image)
	else:
		print("Main introuvable.")
	dialogue_box.show_dialogue("Tu ranges la page. Elle pourrait être importante.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_go_to_hallway)

## Called to transition to the hallway scene.
## Changes the current scene to the hallway.
func _on_go_to_hallway(index: int) -> void:
	var main = get_tree().root.get_node("Main")
	if main:
		main.change_scene("res://scenes/mangakill/hallway.tscn")
	else:
		print("Main introuvable.")
