extends CanvasLayer

@onready var clue_button: Button = $ClueButton
@onready var clue_popup: Popup = $Clues
@onready var clue_label: Label = $Clues/Label

var clues: Array[String] = []

func _ready():
	clue_button.pressed.connect(_on_clue_pressed)

func add_clue(clue: String) -> void:
	if not clue in clues:
		clues.append(clue)

func _on_clue_pressed() -> void:
	if clues.is_empty():
		clue_label.text = "Tu n'as trouvé aucun indice."
	else:
		clue_label.text = "Indices trouvés :\n" + "\n".join(clues)
	clue_popup.popup_centered()
	
func remove_clue() -> void:
	clues.clear()
