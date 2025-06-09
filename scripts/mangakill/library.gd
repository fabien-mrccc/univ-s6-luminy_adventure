extends Node2D

@onready var dialogue_box: Control = $Dialogue
@onready var library_mika: Sprite2D = $LibraryMika
@onready var notebook: Sprite2D = $Notebook

func _ready():
	start_scene()

func start_scene():
	dialogue_box.show_dialogue("Tu entres dans la bibliothèque.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_intro)

func _on_intro(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_intro)
	dialogue_box.show_dialogue("Suzu est agenouillée, cherchant un livre. Elle sursaute en entendant le joueur.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_suzu_reacts)

func _on_suzu_reacts(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_suzu_reacts)
	dialogue_box.show_dialogue("Suzu ? Tu cherches quelque chose ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_player_asks)

func _on_player_asks(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_player_asks)
	dialogue_box.show_dialogue("Suzu (surprise) :\n« Non ! Je… j’ai juste besoin de comprendre ce qui se passe… »", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_suzu_response)

func _on_suzu_response(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_suzu_response)
	dialogue_box.show_dialogue("Tu connais Akira ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_ask_akira)

func _on_ask_akira(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_ask_akira)
	dialogue_box.show_dialogue("Suzu :\n« …Oui. Je l’aimais. Il ne méritait pas ça. Mais je ne l’ai pas tué. »", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_bracelet_notice)

func _on_bracelet_notice(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_bracelet_notice)
	dialogue_box.show_dialogue("Elle baisse les yeux. Le joueur remarque qu'elle ne porte pas de bracelet.", [
		"Parler du bracelet",
		"Lui demander si elle ment",
		"Ne rien dire et observer"
	])
	dialogue_box.choice_selected.connect(_on_suzu_choice)

func _on_suzu_choice(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_suzu_choice)

	match index:
		0:
			dialogue_box.show_dialogue("Suzu devient nerveuse :\n« Je l’ai perdu… pas ici… enfin, je crois… »", ["Suivant"])
		1:
			dialogue_box.show_dialogue("Elle s’énerve et quitte la pièce.", ["Suivant"])
		2:
			dialogue_box.show_dialogue("Elle soupire, prend un livre, et s’en va sans un mot.", ["Suivant"])

	dialogue_box.choice_selected.connect(_on_mika_enters)

func _on_mika_enters(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_mika_enters)
	library_mika.show()
	dialogue_box.show_dialogue("Quelques instants plus tard, Mika entre calmement.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_player_questions_mika)

func _on_player_questions_mika(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_player_questions_mika)
	dialogue_box.show_dialogue("Qu’est-ce que tu lis ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_mika_talks)

func _on_mika_talks(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_mika_talks)
	dialogue_box.show_dialogue("Mika :\n« C’est fascinant… Ce manga se réécrit sous nos yeux. »", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_player_asks_truth)

func _on_player_asks_truth(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_player_asks_truth)
	dialogue_box.show_dialogue("Tu veux dire que tu sais qui l’a tué ?", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_mika_reflects)

func _on_mika_reflects(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_mika_reflects)
	dialogue_box.show_dialogue(
		"Mika : (sourire vague)\n" +
		"« Je me demande ce qui se serait passé s’il n’avait pas ouvert ce tiroir. »\n" +
		"« Je lis juste… les pages qui restent. »\n", 
		["Suivant"]
	)
	dialogue_box.choice_selected.connect(_on_mika_asks)
	
func _on_mika_asks(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_mika_asks)
	dialogue_box.show_dialogue("« Tu crois que le coupable lit aussi cette histoire ? »", 
		[
			"Lui demander directement si c’est elle",
			"Lire par-dessus son épaule",
			"Utiliser la clé pour ouvrir le tiroir"
		]
	)
	dialogue_box.choice_selected.connect(_on_final_choice)

func _on_final_choice(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_final_choice)

	match index:
		0:
			dialogue_box.show_dialogue("Elle sourit étrangement.", ["Accuser"])
		1:
			dialogue_box.show_dialogue("Le texte change en fonction de tes décisions passées.", ["Accuser"])
		2:
			var key_image = load("res://assets/mangakill/Key_clue.png")
			var main = get_tree().root.get_node("Main")
			if key_image in main.clue_layer.get_clues():
				notebook.show()
				dialogue_box.show_dialogue("Tu trouves un carnet :\n« Quelqu’un manipule les pages… Ce n’est plus le monde que j’ai connu. »\nMika regarde, mais comprend-elle ?", ["Prendre l'indice"])
				dialogue_box.choice_selected.connect(_on_take_hint)
			else: 
				dialogue_box.show_dialogue("Tu n'es pas en possession de la clé nécessaire pour ouvrir le tiroir.", ["Accuser"])
		

	dialogue_box.choice_selected.connect(_go_to_accusation)

func _on_take_hint(index: int) -> void:
	var notebook_image = load("res://assets/mangakill/Notebook_clue.png")
	var main = get_tree().root.get_node("Main")
	if main:
		main.add_clue(notebook_image)
	dialogue_box.show_dialogue("Tu prends le carnet", ["Suivant"])
	dialogue_box.choice_selected.connect(_go_to_accusation)

func _go_to_accusation(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_go_to_accusation)
	var main = get_tree().root.get_node("Main")
	if main:
		main.change_scene("res://scenes/mangakill/accusation.tscn")
	else:
		print("Main introuvable.")
	
