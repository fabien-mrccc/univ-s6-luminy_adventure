extends GutTest

var DialogueScene = preload("res://scenes/mangakill/dialogue.tscn")
var dialogue

# Ces variables seront modifiées par le signal
var was_called = false
var selected_index = -1

func before_each():
	dialogue = DialogueScene.instantiate()
	add_child(dialogue)

func after_each():
	if is_instance_valid(dialogue):
		dialogue.queue_free()
		await get_tree().process_frame
	was_called = false
	selected_index = -1

func test_display_label_text():
	dialogue.show_dialogue("Bonjour !", ["Continuer", "Quitter"])
	await get_tree().process_frame

	assert_eq(dialogue.label.text, "Bonjour !")

# 📌 Test: correct number of buttons created
func test_button_count_matches_choices():
	var choices = ["Chercher", "Parler", "Observer"]
	dialogue.show_dialogue("Que veux-tu faire ?", choices)
	await get_tree().process_frame

	assert_eq(dialogue.choices_container.get_child_count(), choices.size())

func test_choice_selected_signal_emits_correct_index():
	dialogue.connect("choice_selected", Callable(self._on_choice_selected))
	dialogue.show_dialogue("Choisis une option :", ["Sauver", "Tuer"])
	await get_tree().process_frame

	dialogue.choices_container.get_child(1).emit_signal("pressed")
	await get_tree().process_frame

	assert_true(was_called)
	assert_eq(selected_index, 1)

func _on_choice_selected(index):
	was_called = true
	selected_index = index
