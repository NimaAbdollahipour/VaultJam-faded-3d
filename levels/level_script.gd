extends Node3D

func _ready() -> void:
	# Store current level for retry functionality
	if has_node("/root/SaveManager"):
		var save_mgr = get_node("/root/SaveManager")
		save_mgr.current_playing_level = get_tree().current_scene.scene_file_path
		print("[Level] Loaded: ", save_mgr.current_playing_level)
	
	# Start game music when level loads
	if has_node("/root/AudioManager"):
		var audio_mgr = get_node("/root/AudioManager")
		audio_mgr.play_game_music()
		print("[Level] Game music started (Background.mp3)")

# Called by player when game over
func game_over() -> void:
	# Use call_deferred to avoid physics callback errors
	get_tree().call_deferred("change_scene_to_file", "res://UI/GameOver.tscn")

# Called by finish line when level complete
func level_complete() -> void:
	# Use call_deferred to avoid physics callback errors
	get_tree().call_deferred("change_scene_to_file", "res://UI/WinScreen.tscn")
