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
	dialogue_box.choice_selected.disconnect(_on_choice)

	match index:
		0, 1, 2:
			await _show_end_dialogue("Voix : Tu t’es trompé...\nTu es condamné à rejouer le même manga. Pour toujours.")
		3:
			Global.manga_kill_finished = true
			await _show_end_dialogue("Mika : (calme) Tu as compris. Ce monde n’est plus à moi. Ferme-le.\nTu es libre.")

func _show_end_dialogue(text: String) -> void:
	dialogue_box.show_dialogue(text, ["Quitter"])
	await get_tree().process_frame
	dialogue_box.choice_selected.connect(_exit)
	
func _exit(index: int) -> void:
	dialogue_box.choice_selected.disconnect(_exit)
	dialogue_box.show_dialogue("")
	get_tree().change_scene_to_file("res://scenes/world.tscn")
