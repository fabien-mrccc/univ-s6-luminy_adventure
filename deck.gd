extends Node3D

var card_scene = preload("res://scenes/card.tscn")
var deck_values = []
var player_cards = []
var ai_cards = []

func _ready():
	deck_values = [1,2,3,4,5,6,7,8,9,10,11]
	deck_values.shuffle()

	# POSITION DE BASE : alignée avec ta table
	var y = 0.3  # hauteur approximative au-dessus de la table

	# 💳 Carte joueur (côté bas de la table)
	for i in range(2):
		var value = deck_values.pop_front()
		var card = card_scene.instantiate()
		card.set_value(value)
		card.position = Vector3(-1 + i * 2.5, y, -1.5)
		add_child(card)
		player_cards.append(card)

	# 💳 Carte IA (côté haut de la table)
	for i in range(2):
		var value = deck_values.pop_front()
		var card = card_scene.instantiate()
		# On laisse le "?" par défaut
		card.position = Vector3(-1 + i * 2.5, y, 1.5)
		add_child(card)
		ai_cards.append(card)
