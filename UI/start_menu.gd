extends Control

@onready var continue_button: Button = $VBoxContainer/ContinueButton

func _ready() -> void:
	# Check if SaveManager is available (it should be as autoload)
	# But since we added it manually to autoload during runtime of this agent, 
	# it might not be recognized by static checks if we aren't careful.
	# However, at runtime, it will be there.
	
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		if not save_manager.has_save():
			continue_button.disabled = true
	else:
		# Fallback if autoload isn't working for some reason
		continue_button.disabled = true
		
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_music()

func _on_continue_pressed() -> void:
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		save_manager.load_game()
		var level = save_manager.current_level_path
		if level and level != "":
			get_tree().change_scene_to_file(level)

func _on_play_pressed() -> void:
	# New Game
	if has_node("/root/SaveManager"):
		var save_manager = get_node("/root/SaveManager")
		save_manager.clear_save()
	
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
