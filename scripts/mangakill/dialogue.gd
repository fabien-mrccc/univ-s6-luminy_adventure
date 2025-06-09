extends Control

@onready var label: Label = $VBoxContainer/Panel/MarginContainer/VBox/Label
@onready var choices_container: GridContainer = $VBoxContainer/Panel/MarginContainer/VBox/ChoicesContainer


signal choice_selected(index: int)

func show_dialogue(text: String, choices: Array = []):
	label.text = text
	
	# Supprimer anciens boutons
	for child in choices_container.get_children():
		child.queue_free()

	# Créer les nouveaux boutons
	for i in choices.size():
		var button = Button.new()
		var font = load("res://assets/mangakill/fonts/PixelOperator8-Bold.ttf")
		button.add_theme_font_override("font", font)
		button.add_theme_font_size_override("size", 30)
		
		button.text = choices[i]
		button.pressed.connect(Callable(self, "_on_choice_pressed").bind(i))
		choices_container.add_child(button)
	
	self.visible = true

func _on_choice_pressed(index):
	emit_signal("choice_selected", index)
