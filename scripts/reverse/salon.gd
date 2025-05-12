extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	dialogue_box.show_dialogue("Tetsuo est affalé, bras en sang.",
		["L'aider à se soigner", "Fouiller discrètement", "L'accuser directement"])
	dialogue_box.choice_selected.connect(_on_choice_selected)

func _on_choice_selected(index):
	dialogue_box.choice_selected.disconnect(_on_choice_selected)

	match index:
		0:
			dialogue_box.show_dialogue("Il semble plus ouvert, partage qu’il soupçonnait Suzu.", ["Suivant"])
		1:
			dialogue_box.show_dialogue("Tu trouves une chemise ensanglantée non portée.", ["Suivant"])
		2:
			dialogue_box.show_dialogue("Il s’énerve : \"Tu veux finir comme Akira ? Va plutôt interroger Mika !\"", ["Suivant"])

	dialogue_box.choice_selected.connect(_on_next_pressed)

func _on_next_pressed(index):
	if index == 0:
		dialogue_box.choice_selected.disconnect(_on_next_pressed)
		get_tree().change_scene_to_file("res://scenes/reverse/couloir.tscn")
