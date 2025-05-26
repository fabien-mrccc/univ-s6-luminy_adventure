extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	start_scene()

func start_scene():
	# Étape 1 : entrée dans le salon
	dialogue_box.show_dialogue("Tu entres dans le salon.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_entered)
	
func _on_entered(index: int) -> void:
	dialogue_box.show_dialogue("Tetsuo, allongé, le bras entaillé profondément.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_intro)

func _on_intro(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_intro)
	dialogue_box.show_dialogue("Joueur : Tetsuo ? T’es blessé ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_player_asks)

func _on_player_asks(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_player_asks)
	dialogue_box.show_dialogue(
		"Tetsuo :\n« Ce n’est pas moi qui me suis fait ça…\nC’est lui. Il était dans ma tête.\nAkira… il devenait fou. »",
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_tetsuo_reply)

func _on_tetsuo_reply(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_tetsuo_reply)
	dialogue_box.show_dialogue(
		"(Il tremble)\n« Il a verrouillé la salle de bain. Disait que 'le vrai monde' était derrière le miroir. »",
		["L’aider à se soigner", "Fouiller discrètement autour de lui", "L’accuser directement"]
	)
	dialogue_box.choice_selected.connect(_on_choice_made)

func _on_choice_made(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_choice_made)

	match index:
		0:
			dialogue_box.show_dialogue(
				"Tetsuo devient lucide un instant :\n« Je crois que Suzu… écrivait à Akira. En secret. »",
				["Découvrir la pièce suivante"]
			)
		1:
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

func _on_blood_found(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_blood_found)
	Clues.add_clue("Chemise ensanglantéé")
	dialogue_box.show_dialogue("Joueur : Ton sang ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_confront_tetsuo)

func _on_confront_tetsuo(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_confront_tetsuo)
	dialogue_box.show_dialogue("Tetsuo :\n« Je… je crois… je ne sais plus quand j’ai saigné pour la dernière fois. »", ["Découvrir la pièce suivante"])
	dialogue_box.choice_selected.connect(_go_to_library)

func _go_to_library(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_go_to_library)
	get_tree().change_scene_to_file("res://scenes/mangakill/library.tscn")
