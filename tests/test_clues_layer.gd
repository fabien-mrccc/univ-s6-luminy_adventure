extends "res://addons/gut/test.gd"

var ClueScene = preload("res://scenes/mangakill/clues_layer.tscn")
var clues

func before_each():
	clues = ClueScene.instantiate()
	add_child(clues)

func after_each():
	if is_instance_valid(clues):
		clues.queue_free()
		await get_tree().process_frame

func test_no_clue_message():
	clues._on_clue_pressed()
	await get_tree().process_frame

	assert_eq(clues.clue_label.text, "Tu n'as trouvé aucun indice.")
	assert_eq(clues.clue_list.get_child_count(), 0)

func test_adds_and_displays_clue():
	var dummy_texture := Texture2D.new()
	clues.add_clue(dummy_texture)

	clues._on_clue_pressed()
	await get_tree().process_frame

	assert_eq(clues.clue_label.text, "")
	assert_eq(clues.clue_list.get_child_count(), 1)

	var added_child = clues.clue_list.get_child(0)
	assert_eq(added_child.texture, dummy_texture)

func test_clue_button_opens_popup():
	clues.add_clue(Texture2D.new())
	clues.clue_button.emit_signal("pressed")
	await get_tree().process_frame

	assert_true(clues.clue_popup.visible)
