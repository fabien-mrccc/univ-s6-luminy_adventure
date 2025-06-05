extends Node3D

@onready var dialogue_ui = $Dialogue
@onready var label_nom = $Dialogue/VBoxContainer/PanelDocument/MarginContainer/ContentBox/Nom
@onready var label_chambre = $Dialogue/VBoxContainer/PanelDocument/MarginContainer/ContentBox/Chambre
@onready var label_raison = $Dialogue/VBoxContainer/PanelDocument/MarginContainer/ContentBox/Raison
@onready var reaction_label = $Dialogue/Reaction
@onready var btn_accept = $Dialogue/VBoxContainer/ChoiseContainer/Accepter
@onready var btn_refuse = $Dialogue/VBoxContainer/ChoiseContainer/Refuser
#@onready var accepted_path = $BotAcceptedPath/AcceptedFollow
#@onready var exit_path = $BotExitPath/ExitFollow


var current_student = {
	"nom": "Jean Dupont",
	"chambre": "C-102",
	"raison": "Je loge ici",
	"reaction_accept": "Merci beaucoup monsieur.",
	"reaction_refuse": "Mais pourquoi ??"
}
func show_document(student_data):
	dialogue_ui.visible = true
	reaction_label.text = ""

	label_nom.text = "Nom : " + student_data.nom
	label_chambre.text = "Chambre : " + student_data.chambre
	label_raison.text = "Raison : " + student_data.raison

	btn_accept.pressed.disconnect_all()
	btn_refuse.pressed.disconnect_all()

	btn_accept.pressed.connect(func(): on_choice(true, student_data))
	btn_refuse.pressed.connect(func(): on_choice(false, student_data))



func on_choice(accepted: bool, student_data):
	dialogue_ui.visible = false
	var bot = get_tree().get_nodes_in_group("Etudiant")[0]

	if accepted:
		reaction_label.text = student_data.reaction_accept
		# move_student_to("inside")  # plus tard
	else:
		reaction_label.text = student_data.reaction_refuse
		bot.call("go_backwards")
