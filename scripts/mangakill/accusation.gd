extends Node2D

@onready var dialogue_box: Control = $Dialogue

func _ready():
	start_accusation()

## Called to initiate the accusation sequence.
## Displays dialogue with multiple accusation choices and connects the selection signal.
func start_accusation():
	dialogue_box.show_dialogue(
		"Voix : Tu ne peux sortir que si tu nommes le coupable. Une seule chance.",
		["Accuser Suzu", "Accuser Tetsuo", "Accuser Ren", "Accuser Mika"]
	)
	dialogue_box.choice_selected.connect(_on_choice)

## Called when the player selects an accusation.
## Displays a dialogue based on the chosen character.
func _on_choice(index: int) -> void:
	match index:
		0: # Suzu
			dialogue_box.show_dialogue(
				"Voix : Tu t’es trompé...\nTu es condamné à rejouer le même manga. Pour toujours."
			)
		1: # Tetsuo
			dialogue_box.show_dialogue(
				"Voix : Tu t’es trompé...\nTu es condamné à rejouer le même manga. Pour toujours."
			)
		2: # Ren
			dialogue_box.show_dialogue(
				"Voix : Tu t’es trompé...\nTu es condamné à rejouer le même manga. Pour toujours."
			)
		3: # Mika
			dialogue_box.show_dialogue(
				"Mika : (calme) Tu as compris. Ce monde n’est plus à moi. Ferme-le.\nTu es libre."
			)
