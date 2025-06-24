extends Node3D

@onready var _World_Ui = $"../WorldUi"
@onready var _dialogue = $UI/dialogue

var _prompt: bool = false

func _on_aphyllanthe_de_montpellier_1_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()


func _on_aphyllanthe_de_montpellier_2_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()


func _on_aphyllanthe_de_montpellier_3_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()


func _on_aphyllanthe_de_montpellier_4_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()


func _on_aphyllanthe_de_montpellier_5_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()


func _on_aphyllanthe_de_montpellier_6_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()


func _on_aphyllanthe_de_montpellier_7_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()


func _on_aphyllanthe_de_montpellier_8_aphyllanthe_found() -> void:
	_World_Ui._update_aphyllanthes()
	


func _on_narcisse_douteux_1_narcisse_found() -> void:
	_World_Ui._update_narcisse()


func _on_narcisse_douteux_2_narcisse_found() -> void:
	_World_Ui._update_narcisse()


func _on_narcisse_douteux_3_narcisse_found() -> void:
	_World_Ui._update_narcisse()


func _on_ciste_2_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_3_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_4_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_5_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_6_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_7_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_8_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_9_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_10_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_ciste_11_ciste_found() -> void:
	_World_Ui._update_ciste()


func _on_interactable_focused(interactor: Interactor) -> void:
	if not _prompt:
		_dialogue.display_line("", "appuyer sur E pour interagir")
		_prompt = true


func _on_interactable_interacted(interactor: Interactor) -> void:
	get_tree().change_scene_to_file("res://scenes/qui_veut_reussir_son_annee/game_batiste.tscn")


func _on_interactable_unfocused(interactor: Interactor) -> void:
	if _prompt:
		_dialogue.close()
		_prompt = false
