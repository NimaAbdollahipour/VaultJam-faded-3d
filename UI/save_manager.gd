extends Node

const SAVE_PATH = "user://savegame.save"
var current_level_path: String = "res://levels/level_1.tscn"

func _ready():
	load_game()

func save_game(level_path: String):
	print("Saving game: ", level_path)
	current_level_path = level_path
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {"level": level_path}
		file.store_line(JSON.stringify(data))
		file.close()

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return # No save
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var data = JSON.parse_string(text)
		if data and "level" in data:
			current_level_path = data["level"]
			print("Loaded game: ", current_level_path)
		file.close()

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func clear_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	current_level_path = "res://levels/level_1.tscn"
