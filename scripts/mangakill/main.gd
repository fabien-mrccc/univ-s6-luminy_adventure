extends Node2D

var clue_layer
var current_scene

func _ready():
	# 1. Créer et ajouter le ClueLayer
	var clue_scene = preload("res://ui/clues_layer.tscn")
	clue_layer = clue_scene.instantiate()
	print("ClueLayer instancié")
	add_child(clue_layer)

	# 2. Charger la première scène de jeu
	change_scene("res://scenes/mangakill/homepage.tscn")

func change_scene(path: String):
	if current_scene:
		current_scene.queue_free()

	current_scene = load(path).instantiate()
	add_child(current_scene)

func add_clue(clue: Texture2D):
	if clue_layer:
		clue_layer.add_clue(clue)
		
	
		
