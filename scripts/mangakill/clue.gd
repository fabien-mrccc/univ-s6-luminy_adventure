extends Node

var indices: Array[String] = []

func ajouter_indice(indice: String):
	if indice not in indices:
		indices.append(indice)

func get_indices():
	return indices
