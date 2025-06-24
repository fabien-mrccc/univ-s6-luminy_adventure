extends CanvasLayer

@onready var clue_button: Button = $ClueButton
@onready var clue_popup: Popup = $Clues
@onready var clue_list: VBoxContainer = $Clues/ScrollContainer/ClueList
@onready var clue_label: Label = $Clues/ScrollContainer/ClueLabel

var clues: Array[Texture2D] = []

## Called when the node enters the scene tree.
## Connects the clue button to its pressed signal.
func _ready():
	clue_button.pressed.connect(_on_clue_pressed)

## Adds a clue texture to the list if it hasn't been added yet.
## Prevents duplicate clues.
func add_clue(clue: Texture2D) -> void:
	if not clue in clues:
		clues.append(clue)

## Called when the clue button is pressed.
## Displays found clues in a popup, or a message if none have been found.
func _on_clue_pressed() -> void:
	
	for child in clue_list.get_children():
		child.queue_free()
			
	if clues.is_empty():
		clue_label.text = "Tu n'as trouvé aucun indice."
		
	else:
		
		clue_label.text = ""
		for clue in clues:
			var texture_rect := TextureRect.new()
			texture_rect.texture = clue
			texture_rect.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
			texture_rect.custom_minimum_size = Vector2(690, 690)
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			clue_list.add_child(texture_rect)
	clue_popup.popup_centered()

## Returns the current list of collected clues.
func get_clues() -> Array[Texture2D]:
	return clues
	
