extends CanvasLayer

@onready var win_panel: Control = $WinPanel
@onready var lose_panel: Control = $LosePanel
@onready var pause_panel: Control = $PausePanel

func _ready() -> void:
	# Ensure panels are hidden at start
	win_panel.visible = false
	lose_panel.visible = false
	pause_panel.visible = false
	
	# Add to group so other objects can call us
	add_to_group("GameManager")
	
	# Stop music during gameplay
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").stop_music()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# Toggle pause if not already ended
		if not win_panel.visible and not lose_panel.visible:
			toggle_pause()

func toggle_pause() -> void:
	if pause_panel.visible:
		# Resume
		pause_panel.visible = false
		get_tree().paused = false
	else:
		# Pause
		pause_panel.visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_resume_pressed() -> void:
	toggle_pause()

func game_over() -> void:
	if win_panel.visible or lose_panel.visible:
		return
		
	lose_panel.visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_music()

func level_complete() -> void:
	if win_panel.visible or lose_panel.visible:
		return
		
	win_panel.visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_music()

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	# Simple check to see if we are in level 1, then go to level 2
	# In a real game, you'd have a level manager.
	var current = get_tree().current_scene.scene_file_path
	var next_level = ""
	
	if "level_1" in current:
		next_level = "res://levels/level_2.tscn"
	# Add more levels here as needed
	
	if next_level != "":
		# Save progress to next level
		if has_node("/root/SaveManager"):
			get_node("/root/SaveManager").save_game(next_level)
		get_tree().change_scene_to_file(next_level)
	else:
		# End of game or unknown level, go back to menu
		get_tree().change_scene_to_file("res://UI/StartMenu.tscn")

func _exit_tree() -> void:
	# When leaving the scene (e.g. to menu), ensure music is playing if we were paused?
	# Actually, if we quit to menu, we want music.
	# If we restart, we want music.
	# If logic is robust, StartMenu calls play_music().
	pass
