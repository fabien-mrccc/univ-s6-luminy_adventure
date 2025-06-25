## Defines grass colors.
extends MultiMeshInstance3D

func _ready():
	if material_override == null:
		material_override = ShaderMaterial.new()
		material_override.shader = preload("res://shaders/grass_shader.gdshader")
	material_override.set_shader_parameter("bottom_color", Color("#7B9B4A")) 
	material_override.set_shader_parameter("top_color", Color("#A3C16B"))  
