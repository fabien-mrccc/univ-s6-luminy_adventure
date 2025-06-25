extends GutTest

# Preloaded NPC scene for instantiating in tests.
# Reference to the NPC node in the instantiated scene.
var npc_scene = preload("res://scenes/tests/test_qui_veut_reussir_son_annee.tscn")
var _50_50_node
var interactor_node
var student_node
var button_node
var answer_node
var dialogue_node
var teacher_node

# Sets up the NPC scene and node before each test case.
func before_each():
	var instance = npc_scene.instantiate()
	add_child(instance)
	await get_tree().process_frame
	interactor_node = instance.get_node("Player/Head/Camera3D/PlayerInteractor")
	_50_50_node = instance.get_node("50_50")
	student_node = instance.get_node("student")
	button_node = instance.get_node("button1")
	answer_node = instance.get_node("teacher/answer1")
	dialogue_node = instance.get_node("UI/dialogue")
	teacher_node = instance.get_node("teacher")

# Cleans up the NPC node after each test case.
func after_each():
	interactor_node.queue_free()
	_50_50_node.queue_free()
	student_node.queue_free()
	button_node.queue_free()
	answer_node.queue_free()
	dialogue_node.queue_free()
	teacher_node.queue_free()



#test 50_50

# Tests the initial interaction prompt display.
func test_interaction_prompt_display_50_50():
	_50_50_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	assert_true(_50_50_node._prompt, "prompt should be open")
	
# Tests the initial explanation dialogue.
func test_initial_explanation_dialogue():
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(_50_50_node._explanation, "The initial explanation should be given")
	assert_true(_50_50_node._talking, "The NPC should be talking")
	assert_eq(dialogue_node._question.text, "reparle moi si tu veut de l'aide mais je ne t'aiderai qu'une seule fois", "The text should be different")

# Tests the 50/50 help generation and dialogue.
func test_50_50_help_generation():
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(_50_50_node._50_50_used, "The 50/50 help should be used")
	assert_eq(_50_50_node._hints.size(), 2, "There should be two hints generated")
	assert_true(_50_50_node._talking, "The NPC should be talking")
	var rep = "la réponse est soit " + str(_50_50_node._hints[0]) +  " soit " + str(_50_50_node._hints[1])
	assert_eq(dialogue_node._question.text, rep, "The text should be different")

# Tests the dialogue when 50/50 help has already been used for the current question.
func test_50_50_already_used_for_current_question():
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(_50_50_node._talking, "The NPC should be talking")
	var rep = "la réponse est soit " + str(_50_50_node._hints[0]) +  " soit " + str(_50_50_node._hints[1])
	assert_eq(dialogue_node._question.text, rep, "The text should be different")

# Tests the dialogue when 50/50 help has already been used for a different question.
func test_50_50_already_used_for_different_question():
	Global.current_question = 0
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	Global.current_question = 1
	_50_50_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(_50_50_node._talking, "The NPC should be talking")
	assert_eq(dialogue_node._question.text, "je t'ai déjà aidé", "The text should be different")

# Tests closing the interaction prompt when the player moves away.
func test_close_interaction_prompt_50_50():
	_50_50_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	_50_50_node._on_interactable_unfocused(interactor_node)
	await get_tree().process_frame
	assert_false(_50_50_node._prompt, "The interaction prompt should be closed")

# Tests the initial state of the answer label.
func test_initial_state_answer():
	assert_true(not answer_node.visible, "The answer label should initially be invisible")



#test answer


# Tests updating the displayed answer text based on the current question.
func test_update_answer_text():
	Global.current_question = 0
	answer_node._next_question()
	await get_tree().process_frame
	assert_eq(answer_node._answer.text, "1) Aix-en-Provence", "The answer text should be updated based on the current question")
	Global.current_question += 1
	answer_node._next_question()
	await get_tree().process_frame
	assert_eq(answer_node._answer.text, "1) Parc national du Mercantour", "The answer text should be updated based on the current question")

# Tests making the label visible on screen.
func test_make_label_visible():
	answer_node._display()
	await get_tree().process_frame
	assert_true(answer_node.visible, "The answer label should be visible")
	
	
	
#test buzzer
	

# Tests the initial interaction prompt display.
func test_interaction_prompt_display_buzzer():
	button_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	assert_true(button_node.prompt, "The interaction prompt should be displayed")

# Tests the interaction with the buzzer button when the quiz is not finished.
func test_interact_with_buzzer_not_finished():
	Global.current_question = 0
	Global.answers = [1, 2, 3]
	Global.answer = false
	button_node._button.set_meta("id", 1)
	button_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(Global.answer, "An answer should be recorded")
	assert_true(Global.good_answer, "The answer should be marked as correct")

# Tests the interaction with the buzzer button when the quiz is finished.
func test_interact_with_buzzer_finished():
	Global.current_question = 3
	Global.answers = [1, 2, 3]
	button_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(Global.current_question >= Global.answers.size(), "The quiz should be over")

# Tests the interaction with the buzzer button when an answer has already been given.
func test_interact_with_buzzer_already_answered():
	Global.current_question = 0
	Global.answers = [1, 2, 3]
	Global.answer = true
	button_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(Global.answer, "An answer should already have been given")

# Tests closing the interaction prompt when the player moves away.
func test_close_interaction_prompt_buzzer():
	button_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	button_node._on_interactable_unfocused(interactor_node)
	await get_tree().process_frame
	assert_false(button_node.prompt, "The interaction prompt should be closed")


#test dialogue

# Tests the initial state of the dialogue UI.
func test_initial_state_dialogue():
	assert_false(dialogue_node.visible, "The dialogue UI should initially be invisible")

# Tests displaying a line of dialogue.
func test_display_line_dialogue():
	var speaker = "Test"
	var line = "Test line."
	dialogue_node.display_line(speaker, line)
	await get_tree().process_frame
	assert_true(dialogue_node.visible, "The dialogue UI should be visible")
	assert_true(dialogue_node._name.text == speaker, "The speaker's name should be displayed correctly")
	assert_true(dialogue_node._question.text == line, "The dialogue line should be displayed correctly")

# Tests opening the dialogue UI.
func test_open_dialogue_ui():
	dialogue_node.open()
	await get_tree().process_frame
	assert_true(dialogue_node.visible, "The dialogue UI should be visible")

# Tests closing the dialogue UI.
func test_close_dialogue_ui():
	dialogue_node.open()
	await get_tree().process_frame
	dialogue_node.close()
	await get_tree().process_frame
	assert_false(dialogue_node.visible, "The dialogue UI should be invisible")


#test student

# Tests the initial interaction prompt display.
func test_interaction_prompt_display():
	student_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	assert_true(student_node._prompt, "The interaction prompt should be displayed")

# Tests the initial explanation dialogue.
func test_initial_explanation_dialogue_student():
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(student_node._explanation, "The initial explanation should be given")
	assert_true(student_node._talking, "The NPC should be talking")
	assert_eq(dialogue_node._question.text, "reparle moi si tu veut de l'aide mais je ne t'aiderai qu'une seule fois", "The text should be different")

# Tests the direct help provided by the NPC.
func test_direct_help_provided():
	Global.current_question = 0
	Global.answers = ["1"]
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(student_node._friend_used, "The friend help should be used")
	assert_true(student_node._talking, "The NPC should be talking")
	assert_eq(dialogue_node._question.text, "Il me semble que la réponse est 1", "The text should be different")

# Tests the dialogue when help has already been used for the current question.
func test_help_already_used_for_current_question():
	Global.current_question = 0
	Global.answers = ["1"]
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(student_node._talking, "The NPC should be talking")
	assert_eq(dialogue_node._question.text, "Il me semble que la réponse est 1", "The text should be different")

# Tests the dialogue when help has already been used for a different question.
func test_help_already_used_for_different_question():
	Global.current_question = 0
	Global.answers = ["1", "2", "3"]
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	Global.current_question = 1
	student_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert(student_node._talking, "The NPC should be talking")
	assert_eq(dialogue_node._question.text, "je t'ai déjà aidé", "The text should be different")

# Tests closing the interaction prompt when the player moves away.
func test_close_interaction_prompt():
	student_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	student_node._on_interactable_unfocused(interactor_node)
	await get_tree().process_frame
	assert_false(student_node._prompt, "The interaction prompt should be closed")
	
	


#test teacher


# Tests the initial interaction prompt display.
func test_interaction_prompt_display_teacher():
	teacher_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	assert_true(teacher_node.prompt, "The interaction prompt should be displayed")

# Tests displaying questions and answers on interaction.
func test_display_questions_and_answers():
	Global.current_question = 0
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(teacher_node.question_shown, "The questions should be displayed")
	#assert_eq(answer_node._answer.text, "1) Aix-en-Provence", "The NPC should be talking")
	assert_eq(answer_node._answer.text, "1) Parc national du Mercantour", "The NPC should be talking")

# Tests the initial dialogue interaction.
func test_initial_dialogue_interaction():
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(teacher_node.talking, "The NPC should be talking")
	assert_eq(dialogue_node._question.text, "Bonjour, les questions sont au tableau", "The NPC should be talking")

# Tests handling a correct answer.
func test_handle_correct_answer():
	Global.current_question = 0
	Global.answers = [1, 2]
	Global.answer = true
	Global.good_answer = true
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(teacher_node.talking, "The NPC should acknowledge the correct answer")
	assert_eq(Global.current_question, 1, "The current question should be incremented")
	assert_eq(dialogue_node._question.text, "Bonne réponse", "The current question should be incremented")

# Tests handling a wrong answer.
func test_handle_wrong_answer():
	Global.current_question = 0
	Global.answers = [1, 2]
	Global.answer = true
	Global.good_answer = false
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_true(teacher_node.talking, "The NPC should acknowledge the wrong answer")
	assert_eq(Global.current_question, 1, "The current question should be incremented")
	assert_eq(dialogue_node._question.text, "Mauvaise réponse", "The current question should be incremented")

# Tests finishing the quiz.
func test_finish_quiz():
	Global.current_question = 3
	Global.answers = [1, 2, 3, 4]
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	button_node._button.set_meta("id", 1)
	button_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	teacher_node._on_interactable_interacted(interactor_node)
	await get_tree().process_frame
	assert_eq(dialogue_node._question.text, "Le quiz est fini", "The current question should be incremented")

# Tests closing the interaction prompt when the player moves away.
func test_close_interaction_prompt_teacher():
	teacher_node._on_interactable_focused(interactor_node)
	await get_tree().process_frame
	teacher_node._on_interactable_unfocused(interactor_node)
	await get_tree().process_frame
	assert_false(teacher_node.prompt, "The interaction prompt should be closed")
