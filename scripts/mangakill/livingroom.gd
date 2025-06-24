extends Node2D

@onready var dialogue_box: Control = $Dialogue
@onready var shirt: Sprite2D = $Shirt

func _ready():
	start_scene()

## Starts the living room scene dialogue.
## Shows the initial text and connects to next step.
func start_scene():
	dialogue_box.show_dialogue("Tu entres dans le salon.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_entered)
	
## Shows Tetsuo injured and connects to intro dialogue.
func _on_entered(index: int) -> void:
	dialogue_box.show_dialogue("Tetsuo, allongé, le bras entaillé profondément.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_intro)

## Player asks Tetsuo about his injury.
func _on_intro(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_intro)
	dialogue_box.show_dialogue("Joueur : Tetsuo ? T’es blessé ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_player_asks)

## Tetsuo explains his injury and mentions Akira.
func _on_player_asks(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_player_asks)
	dialogue_box.show_dialogue(
		"Tetsuo :\n« Ce n’est pas moi qui me suis fait ça…\nC’est lui. Il était dans ma tête.\nAkira… il devenait fou. »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_tetsuo_reply)

## Presents player with choices for action.
func _on_tetsuo_reply(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_tetsuo_reply)
	dialogue_box.show_dialogue(
		"(Il tremble)\n« Il a verrouillé la salle de bain. Disait que 'le vrai monde' était derrière le miroir. »",
		["L’aider à se soigner", "Fouiller discrètement autour de lui", "L’accuser directement"]
	)
	dialogue_box.choice_selected.connect(_on_choice_made)

## Handles player's choice after Tetsuo’s reply.
## Shows different responses and clues based on selection.
func _on_choice_made(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_choice_made)

	match index:
		0:
			dialogue_box.show_dialogue(
				"Tetsuo devient lucide un instant :\n« Je crois que Suzu… écrivait à Akira. En secret. »",
				["Découvrir la pièce suivante"]
			)
		1:
			shirt.show()
			dialogue_box.show_dialogue(
				"Une chemise ensanglantée, mais le sang est trop frais pour être celui d’un mort.",
				["Prendre l'indice"]
			)
			dialogue_box.choice_selected.connect(_on_blood_found)
		2:
			dialogue_box.show_dialogue(
				"Tetsuo hurle :\n« Tu fais exactement ce qu’il veut ! C’est *lui* qui tourne les pages ! »",
				["Découvrir la pièce suivante"]
			)
			dialogue_box.choice_selected.connect(_go_to_library)


## Handles clue found on the bloody shirt.
## Adds clue to main and continues conversation.
func _on_blood_found(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_blood_found)
	var shirt_image = load("res://assets/mangakill/Shirt_clue.png")
	var main = get_tree().root.get_node("Main")
	if main:
		main.add_clue(shirt_image)
	dialogue_box.show_dialogue("Joueur : Ton sang ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_confront_tetsuo)


## Tetsuo responds about his bleeding.
## Connects to transition to library scene.
func _on_confront_tetsuo(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_confront_tetsuo)
	dialogue_box.show_dialogue("Tetsuo :\n« Je… je crois… je ne sais plus quand j’ai saigné pour la dernière fois. »", ["Découvrir la pièce suivante"])
	dialogue_box.choice_selected.connect(_go_to_library)

## Changes scene to the library.
func _go_to_library(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_go_to_library)
	var main = get_tree().root.get_node("Main")
	if main:
		main.change_scene("res://scenes/mangakill/library.tscn")
	else:
		print("Main introuvable.")
