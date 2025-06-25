extends Resource
class_name Save

@export var qui_veut_reussir_son_annee:bool = false
@export var luminy_for_speed:bool = false
@export var control_room:bool = false
@export var manga_kill:bool = false
@export var botanic_cistes:bool = false
@export var botanic_aphyllanthes:bool = false
@export var botanic_narcisses:bool = false

## Save game done
func _valid_qui_veut_reussir_son_annee():
	qui_veut_reussir_son_annee = true

## Save game done
func _valid_luminy_for_speed():
	luminy_for_speed = true
	
## Save game done
func _valid_control_room():
	control_room = true

## Save game done
func _valid_manga_kill():
	manga_kill = true

## Save game done
func _valid_botanic_cistes():
	botanic_cistes = true

## Save game done
func _valid_botanic_aphyllanthes():
	botanic_aphyllanthes = true

## Save game done
func _valid_botanic_narcisses():
	botanic_narcisses = true
