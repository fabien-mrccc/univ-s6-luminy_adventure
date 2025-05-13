extends Node3D

# On prépare le chemin vers la scène Card.tscn
var card_scene = preload("res://scenes/card.tscn")

# Liste des valeurs des cartes de 1 à 11
var values = [1,2,3,4,5,6,7,8,9,10,11]

func _ready():
	# On affiche les cartes au démarrage de la scène
	for i in values:
		var card = card_scene.instantiate()
		card.set_value(i)

		# Positionne la carte dans l'espace 3D (décalées sur X)
		card.position = Vector3(i * 1.2, 0.5, 0)

		# Ajoute la carte comme enfant de Deck (visible dans la scène)
		add_child(card)
