extends CanvasLayer

@onready var clue_button: Button = $ClueButton
@onready var clue_popup: Popup = $Clues
@onready var clue_list: VBoxContainer = $Clues/ScrollContainer/ClueList
@onready var label: Label = $Clues/ScrollContainer/Label

var clues: Array[Texture2D] = []

func _ready():
	clue_button.pressed.connect(_on_clue_pressed)

func add_clue(clue: Texture2D) -> void:
	if not clue in clues:
		clues.append(clue)

func _on_clue_pressed() -> void:
	
	for child in clue_list.get_children():
		child.queue_free()
			
	if clues.is_empty():
		label.text = "Tu n'as trouvé aucun indice."
		
	else:
		
		label.text = ""
		for clue in clues:
			var texture_rect := TextureRect.new()
			texture_rect.texture = clue
			texture_rect.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
			texture_rect.custom_minimum_size = Vector2(985, 985)
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			clue_list.add_child(texture_rect)
	clue_popup.popup_centered()

func get_clues() -> Array[Texture2D]:
	return clues
	
