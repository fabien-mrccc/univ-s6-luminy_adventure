extends Node2D

@onready var play_button: Button = $PlayButton
@onready var dialogue_box: Control = $Dialogue

# Liste des parties du contexte à afficher
var contexte_parts = [
	"Tu n’as aucun souvenir d’avant. Tu te réveilles dans un monde dessiné, un manga oublié, où chaque page semble t’espionner.",
	"Un nom résonne dans ta tête comme une cicatrice : Akira.\nOn dit qu’il s’est suicidé. Mais… quelque chose cloche.\nLes cases changent. Les dialogues s’effacent.",
	"Quelqu’un réécrit l’histoire pendant que tu la vis.\n\nEt si tu ne découvres pas la vérité, tu seras la prochaine rature.",
	"Ton seul espoir : trouver qui tire les ficelles… et accuser avant qu’il ne soit trop tard."
]

var contexte_index := 0

func _ready():
	play_button.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	play_button.hide()
	dialogue_box.show()
	_show_next_context()

func _show_next_context():
	if contexte_index < contexte_parts.size():
		dialogue_box.show_dialogue(contexte_parts[contexte_index], ["Suivant"])
		dialogue_box.choice_selected.connect(_on_suivant_pressed)
	else:
		var main = get_tree().root.get_node("Main")
		if main:
			main.change_scene("res://scenes/mangakill/bedroom.tscn")
		else:
			print("Main introuvable")
func _on_suivant_pressed(index):
	if index == 0:
		dialogue_box.choice_selected.disconnect(_on_suivant_pressed)
		contexte_index += 1
		_show_next_context()
