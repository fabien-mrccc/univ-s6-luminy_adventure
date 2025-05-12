extends Control

@onready var label: Label = $Panel/MarginContainer/VBoxContainer/Label
@onready var choices_container: GridContainer = $Panel/MarginContainer/VBoxContainer/ChoicesContainer

signal choice_selected(index: int)

func show_dialogue(text: String, choices: Array = []):
	label.text = text
	
	# Supprimer anciens boutons
	for child in choices_container.get_children():
		child.queue_free()

	# Créer les nouveaux boutons
	for i in choices.size():
		var button = Button.new()
		button.text = choices[i]
		button.pressed.connect(Callable(self, "_on_choice_pressed").bind(i))
		choices_container.add_child(button)
	
	self.visible = true

func _on_choice_pressed(index):
	emit_signal("choice_selected", index)
