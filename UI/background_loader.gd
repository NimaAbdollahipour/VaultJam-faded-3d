@tool
extends TextureRect

@export var texture_path: String = ""

func _ready() -> void:
	if texture_path != "":
		load_texture_safe()

func load_texture_safe() -> void:
	if FileAccess.file_exists(texture_path):
		var tex = load(texture_path)
		if tex:
			texture = tex
		else:
			# Fallback
			var img = Image.new()
			if img.load(texture_path) == OK:
				texture = ImageTexture.create_from_image(img)
	else:
		print("Background texture not found: ", texture_path)
