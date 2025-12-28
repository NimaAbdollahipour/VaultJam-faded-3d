extends Control

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var retry_button: Button = $VBoxContainer/RetryButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

var last_level: String = "res://levels/level_1.tscn"
var next_level: String = ""

func _ready() -> void:
	# Get the level that was just completed
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		
		# Get current playing level
		if save_manager.current_playing_level != "":
			last_level = save_manager.current_playing_level
		
		# Determine next level and unlock it
		if "level_1" in last_level:
			next_level = "res://levels/level_2.tscn"
			save_manager.unlock_level(2)  # Unlock level 2
		elif "level_2" in last_level:
			next_level = "res://levels/level_3.tscn"
			save_manager.unlock_level(3)  # Unlock level 3
		elif "level_3" in last_level:
			next_level = "res://levels/level_4.tscn"
			save_manager.unlock_level(4)  # Unlock level 4
		elif "level_4" in last_level:
			next_level = "" # No more levels yet
		
		print("[WinScreen] Current: ", last_level)
		print("[WinScreen] Next: ", next_level if next_level != "" else "None")
	
	# Disable continue if no next level
	if next_level == "":
		continue_button.disabled = true
		continue_button.text = "NO MORE LEVELS"
	
	# Connect buttons
	continue_button.pressed.connect(_on_continue_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Play win sound and menu music
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("win")
		get_node("/root/AudioManager").play_menu_music()

func _on_continue_pressed() -> void:
	if next_level != "":
		# Save progress to next level
		if has_node("/root/SaveManager"):
			get_node("/root/SaveManager").save_game(next_level)
		
		get_tree().change_scene_to_file(next_level)

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file(last_level)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/StartMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
