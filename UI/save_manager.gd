extends Node

const SAVE_PATH = "user://savegame.save"
var current_level_path: String = "res://levels/level_1.tscn"
var current_playing_level: String = "" # Tracks which level is currently being played
var unlocked_levels: Array = [1]  # Track which levels are unlocked (Level 1 always unlocked)

func _ready():
	load_game()

func save_game(level_path: String):
	print("Saving game: ", level_path)
	current_level_path = level_path
	
	var save_data = {
		"level": level_path,
		"unlocked_levels": unlocked_levels
	}
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		var json_string = JSON.stringify(save_data)
		save_file.store_line(json_string)
		save_file.close()
		print("Game saved successfully")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		unlocked_levels = [1]  # Default: only level 1 unlocked
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file:
		var json_string = save_file.get_line()
		save_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var save_data = json.data
			if save_data and typeof(save_data) == TYPE_DICTIONARY:
				current_level_path = save_data.get("level", "res://levels/level_1.tscn")
				unlocked_levels = save_data.get("unlocked_levels", [1])
				print("Loaded game: ", current_level_path)
				print("Unlocked levels: ", unlocked_levels)

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func clear_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	current_level_path = "res://levels/level_1.tscn"
	unlocked_levels = [1]

# Unlock a specific level
func unlock_level(level_number: int) -> void:
	if not level_number in unlocked_levels:
		unlocked_levels.append(level_number)
		unlocked_levels.sort()  # Keep sorted
		print("[SaveManager] Unlocked level ", level_number)
		print("[SaveManager] Unlocked levels now: ", unlocked_levels)
		# Force save immediately
		var current_path = current_level_path if current_level_path != "" else "res://levels/level_1.tscn"
		save_game(current_path)
	else:
		print("[SaveManager] Level ", level_number, " already unlocked")

# Check if a level is unlocked
func is_level_unlocked(level_number: int) -> bool:
	var unlocked = level_number in unlocked_levels
	print("[SaveManager] Checking level ", level_number, " - Unlocked: ", unlocked, " (Array: ", unlocked_levels, ")")
	return unlocked
