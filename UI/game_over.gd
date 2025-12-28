extends Control

@onready var retry_button: Button = $VBoxContainer/RetryButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

var last_level: String = "res://levels/level_1.tscn"

func _ready() -> void:
	# Get the level that was just being played
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		if save_manager.current_playing_level != "":
			last_level = save_manager.current_playing_level
		print("[GameOver] Retry will load: ", last_level)
	
	# Connect buttons
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Play lose sound and menu music
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("lose")
		get_node("/root/AudioManager").play_menu_music()

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file(last_level)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/StartMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
