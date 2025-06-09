extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	start_accusation()

func start_accusation():
	dialogue_box.show_dialogue(
		"Voix : Tu ne peux sortir que si tu nommes le coupable. Une seule chance.",
		["Accuser Suzu", "Accuser Tetsuo", "Accuser Ren", "Accuser Mika"]
	)
	dialogue_box.choice_selected.connect(_on_choice)

func _on_choice(index: int) -> void:
	match index:
		0: # Suzu
			dialogue_box.show_dialogue(
				"Voix : Tu t’es trompé...\n(L’écran devient noir. Tu es condamné à rejouer le même manga. Pour toujours.)"
			)
		1: # Tetsuo
			dialogue_box.show_dialogue(
				"Voix : Tu t’es trompé...\n(L’écran devient noir. Tu es condamné à rejouer le même manga. Pour toujours.)"
			)
		2: # Ren
			dialogue_box.show_dialogue(
				"Voix : Tu t’es trompé...\n(L’écran devient noir. Tu es condamné à rejouer le même manga. Pour toujours.)"
			)
		3: # Mika
			dialogue_box.show_dialogue(
				"Mika : (calme) Tu as compris. Ce monde n’est plus à moi. Ferme-le.\n(Le livre se referme. Tu es libre.)"
			)
