extends Node2D

@onready var dialogue_box: Control = $Dialogue
@onready var bathroom_mirror: Sprite2D = $BathroomMirror
@onready var bracelet: Sprite2D = $Bracelet
@onready var key: Sprite2D = $Key

func _ready():
	start_scene()

## Called to begin the bathroom scene.
## Displays an introductory dialogue and connects the selection signal.
func start_scene():
	dialogue_box.show_dialogue("Tu entres dans la salle de bain.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_entered)

## Called after the player enters the bathroom.
## Updates the dialogue and prepares the next scene step by reconnecting the signal.
func _on_entered(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_entered)
	dialogue_box.show_dialogue("L’endroit est anormalement silencieux.", ["Suivant"])
	dialogue_box.choice_selected.connect(_on_silence)

## Called after the silence dialogue is displayed.
## Presents the player with multiple choices for interaction in the bathroom.
func _on_silence(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_silence)
	dialogue_box.show_dialogue(
		"Le miroir est fissuré. Il tremble légèrement… comme s’il respirait.\nL’eau du lavabo est trouble, rougeâtre.",
		["Inspecter le miroir", "Inspecter le lavabo", "Sortir sans rien inspecter"]
	)
	dialogue_box.choice_selected.connect(_on_bathroom_choice)

## Called when the player makes a choice in the bathroom.
## Triggers a different outcome based on the selected option.
func _on_bathroom_choice(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_on_bathroom_choice)

	match index:
		0:
			bathroom_mirror.show()
			dialogue_box.show_dialogue(
				"Ton reflet te regarde… et cligne des yeux en décalé. Il n'est pas toi.",
				["Découvrir la pièce suivante"]
			)
			dialogue_box.choice_selected.connect(_go_to_livingroom)
		1:
			key.show()
			bracelet.show()
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


## Called when the player chooses to take the hint.
## Adds the key and bracelet as clues and transitions to the next scene.
func _on_take_hint(index: int) -> void:
	var key_image = load("res://assets/mangakill/Key_clue.png")
	var bracelet_image = load("res://assets/mangakill/Bracelet_clue.png")
	var main = get_tree().root.get_node("Main")
	if main:
		main.add_clue(key_image)
		main.add_clue(bracelet_image)
	dialogue_box.show_dialogue("Tu prends la clé et le bracelet et tu sors de la salle de bain", ["Découvrir la pièce suivante"])
	dialogue_box.choice_selected.connect(_go_to_livingroom)
	
## Called to transition from the bathroom to the living room.
## Changes the current scene to the living room.
func _go_to_livingroom(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_go_to_livingroom)
	var main = get_tree().root.get_node("Main")
	if main:
		main.change_scene("res://scenes/mangakill/livingroom.tscn")
	else:
		print("Main introuvable.")
