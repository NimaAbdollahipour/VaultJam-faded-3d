extends Control

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var levels_button: Button = $VBoxContainer/LevelsButton if has_node("VBoxContainer/LevelsButton") else null
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	# Check if there's a saved game to enable/disable Continue button
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		continue_button.disabled = not save_manager.has_save()
	
	# Only connect signals if they're not already connected (scene connections exist)
	# The StartMenu.tscn has signal connections built-in, so we don't need to connect here
	
	# Connect levels button if it exists
	if levels_button:
		if not levels_button.pressed.is_connected(_on_levels_pressed):
			levels_button.pressed.connect(_on_levels_pressed)
	
	# Play menu music
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_menu_music()

func _on_continue_pressed() -> void:
	# Load saved game
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		save_manager.load_game()
		var level_to_load = save_manager.current_level_path
		if level_to_load != "":
			get_tree().change_scene_to_file(level_to_load)

func _on_play_pressed() -> void:
	# New game - reset save
	if has_node("/root/SaveManager"):
		get_node("/root/SaveManager").clear_save()
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_levels_pressed() -> void:
	# Open level selection screen
	get_tree().change_scene_to_file("res://UI/LevelSelection.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
