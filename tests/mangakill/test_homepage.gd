extends GutTest

var scene
var play_button
var dialogue_box

func before_each():
	var packed_scene = preload("res://scenes/mangakill/test_mangakill.tscn")
	scene = packed_scene.instantiate()
	add_child(scene)
	await get_tree().process_frame

	play_button = scene.get_node("PlayButton")
	
	# Création d'un faux dialogue_box
	var fake_dialogue = Node.new()
	fake_dialogue.set_name("Dialogue")
	fake_dialogue.add_user_signal("choice_selected")
	fake_dialogue.show_dialogue = func(text, options): pass
	
	scene.dialogue_box = fake_dialogue
	scene.add_child(fake_dialogue)

func test_play_button_cache_et_affiche_dialogue():
	# Simule un clic sur le bouton
	play_button.emit_signal("pressed")

	assert_false(play_button.visible, "Le bouton Play doit être caché après clic")
	assert_true(dialogue_box.visible, "La boîte de dialogue doit être affichée après clic")

func test_sequence_de_contexte_avance_correctement():
	scene.contexte_index = 0
	var appelé = false
	
	# Simule une version contrôlée de show_dialogue
	dialogue_box.show_dialogue = func(text, options):
		appelé = true
		assert_eq(text, scene.contexte_parts[0], "Le premier texte de contexte doit être affiché")

	scene._show_next_context()

	assert_true(appelé, "show_dialogue doit être appelé pour afficher le premier contexte")

func test_fin_du_contexte_change_la_scene():
	scene.contexte_index = scene.contexte_parts.size()
	
	var change_called = false
	var original_change_scene = scene.get_tree().change_scene_to_file
	scene.get_tree().change_scene_to_file = func(path):
		change_called = true
		return OK

	scene._show_next_context()
	
	assert_true(change_called, "La scène doit changer une fois tout le contexte affiché")

	# Restaure la méthode originale pour éviter les effets de bord
	scene.get_tree().change_scene_to_file = original_change_scene
