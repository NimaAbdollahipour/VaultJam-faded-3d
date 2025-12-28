extends Control

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var fade_mode_checkbox: CheckBox = $VBoxContainer/FadeModeCheckbox

# Global fade mode setting
var platforms_always_fade: bool = false

func _ready() -> void:
	# Check if SaveManager is available
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		if not save_manager.has_save():
			continue_button.disabled = true
	else:
		# Fallback if autoload isn't working for some reason
		continue_button.disabled = true
		
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_music()
	
	# Connect fade mode checkbox
	if fade_mode_checkbox:
		fade_mode_checkbox.toggled.connect(_on_fade_mode_toggled)
	
	# Load saved fade mode preference
	_load_fade_mode_setting()

func _load_fade_mode_setting() -> void:
	if FileAccess.file_exists("user://fade_mode.cfg"):
		var file = FileAccess.open("user://fade_mode.cfg", FileAccess.READ)
		if file:
			platforms_always_fade = file.get_8() == 1
			fade_mode_checkbox.button_pressed = platforms_always_fade
			file.close()

func _on_fade_mode_toggled(checked: bool) -> void:
	platforms_always_fade = checked
	# Save preference
	var file = FileAccess.open("user://fade_mode.cfg", FileAccess.WRITE)
	if file:
		file.store_8(1 if checked else 0)
		file.close()
	
	print("[MENU] Fade mode set to: ", "Always" if checked else "When Standing")

func _on_continue_pressed() -> void:
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		save_manager.load_game()
		var level = save_manager.current_level_path
		if level and level != "":
			_apply_fade_mode_to_level()
			get_tree().change_scene_to_file(level)

func _on_play_pressed() -> void:
	# New Game
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		save_manager.clear_save()
	
	_apply_fade_mode_to_level()
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _apply_fade_mode_to_level() -> void:
	# Store setting in a global autoload or scene tree metadata
	get_tree().root.set_meta("platforms_always_fade", platforms_always_fade)

func _on_quit_pressed() -> void:
	get_tree().quit()
