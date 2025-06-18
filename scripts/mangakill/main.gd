extends Node2D

var clue_layer
var current_scene

## Called when the node enters the scene tree.
## Instantiates the clue layer from its scene and adds it as a child.
## Then changes the current scene to the homepage scene.
func _ready():
	var clue_scene = preload("res://ui/clues_layer.tscn")
	clue_layer = clue_scene.instantiate()
	print("ClueLayer instancié")
	add_child(clue_layer)

	change_scene("res://scenes/mangakill/homepage.tscn")

## Changes the current scene to the one specified by the given path.
## Frees the previous scene if it exists, loads the new scene, instantiates it, and adds it as a child.
func change_scene(path: String):
	if current_scene:
		current_scene.queue_free()

	current_scene = load(path).instantiate()
	add_child(current_scene)

## Adds a clue texture to the clue layer if it exists.
func add_clue(clue: Texture2D):
	if clue_layer:
		clue_layer.add_clue(clue)
		
	
		
