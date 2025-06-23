extends Control

@onready var label: Label = $VBoxContainer/Panel/MarginContainer/VBox/Label
@onready var choices_container: GridContainer = $VBoxContainer/Panel/MarginContainer/VBox/ChoicesContainer

## Emitted when a dialogue choice is selected.
## Sends the index of the selected choice.
signal choice_selected(index: int)

## Displays dialogue text with optional choice buttons.
## Clears previous choices and sets up new ones, then shows the dialogue box.
func show_dialogue(text: String, choices: Array = []):
	label.text = text
	
	for child in choices_container.get_children():
		child.queue_free()

	for i in choices.size():
		var button = Button.new()
		button.add_theme_color_override("font_color", Color(0.75,0,0))
		var font = load("res://assets/mangakill/fonts/PixelOperator8-Bold.ttf")
		button.add_theme_font_override("font", font)
		button.add_theme_font_size_override("font_size", 30)
		button.text = choices[i]
		button.pressed.connect(Callable(self, "_on_choice_pressed").bind(i))
		choices_container.add_child(button)
	
	self.visible = true

## Called when a dialogue choice is pressed.
## Emits the choice_selected signal with the selected index.
func _on_choice_pressed(index):
	emit_signal("choice_selected", index)
