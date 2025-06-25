extends Node2D

@onready var _checkBox_qui_veut_reussir_son_annee = $CanvasLayer/Control/VBoxContainer/HBoxContainer1/CheckBox1
@onready var _checkBox_luminy_for_speed = $CanvasLayer/Control/VBoxContainer/HBoxContainer2/CheckBox2
@onready var _checkBox_control_room = $CanvasLayer/Control/VBoxContainer/HBoxContainer3/CheckBox3
@onready var _checkBox_manga_kill = $CanvasLayer/Control/VBoxContainer/HBoxContainer4/CheckBox4
@onready var _checkBox_botanic_cistes = $CanvasLayer/Control/VBoxContainer/HBoxContainer5/CheckBox5
@onready var _checkBox_botanic_aphyllanthes = $CanvasLayer/Control/VBoxContainer/HBoxContainer6/CheckBox6
@onready var _checkBox_botanic_narcisses = $CanvasLayer/Control/VBoxContainer/HBoxContainer7/CheckBox7
@onready var _player = $"../Player"

## Updates the aphyllanthes progress UI and handles completion state.
func _update_aphyllanthes():
	if _player.save.botanic_aphyllanthes:
		Global.current_botanic_aphyllanthes = Global.total_botanic_aphyllanthes
	_checkBox_botanic_aphyllanthes.text = "Botanique : Trouver " + str(Global.current_botanic_aphyllanthes) + "/" + str(Global.total_botanic_aphyllanthes) + " Aphyllanthes de Montpellier"
	if Global.current_botanic_aphyllanthes == Global.total_botanic_aphyllanthes:
		_checkBox_botanic_aphyllanthes.button_pressed = true
		_player.save._valid_botanic_aphyllanthes()
		_player._save()

## Updates the narcisses progress UI and handles completion state.
func _update_narcisse():
	if _player.save.botanic_narcisses:
		Global.current_botanic_narcisses = Global.total_botanic_narcisses
	_checkBox_botanic_narcisses.text = "Botanique : Trouver " + str(Global.current_botanic_narcisses) + "/" + str(Global.total_botanic_narcisses) + " Narcisses douteux"
	if Global.current_botanic_narcisses == Global.total_botanic_narcisses:
		_checkBox_botanic_narcisses.button_pressed = true
		_player.save._valid_botanic_narcisses()	
		_player._save()
		
## Updates the ciste progress UI and handles completion state.
func _update_ciste():
	if _player.save.botanic_cistes:
		Global.current_ciste = Global.total_ciste
	_checkBox_botanic_cistes.text = "Botanique : Trouver " + str(Global.current_ciste) + "/" + str(Global.total_ciste) + " Cistes"
	if Global.current_ciste == Global.total_ciste:
		_checkBox_botanic_cistes.button_pressed = true
		_player.save._valid_botanic_cistes()
		_player._save()

## Updates the "Who wants to pass the year" checkbox.	
func _update_qui_veut_reussir_son_annee():
	if _player.save.qui_veut_reussir_son_annee:
		_checkBox_qui_veut_reussir_son_annee.button_pressed = true

## Updates the Luminy For Speed progress and handles completion.
func _update_luminy_for_speed():
	if Global.lfs:
		_player.save._valid_luminy_for_speed()
		_player._save()
	
	if _player.save.luminy_for_speed:
		_checkBox_luminy_for_speed.button_pressed = true

## Updates the control room checkbox.	
func _update_control_room():
	if _player.save.control_room:
		_checkBox_control_room.button_pressed = true

## Updates the Manga Kill progress and handles completion.
func _update_manga_kill():
	if Global.manga_kill_finished:
		print(Global.manga_kill_finished)
		_player.save._valid_manga_kill()
		_player._save()
		print(_player.save._valid_manga_kill())
	
	if _player.save.manga_kill:
		_checkBox_manga_kill.button_pressed = true
