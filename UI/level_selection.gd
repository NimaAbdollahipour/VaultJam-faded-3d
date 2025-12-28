extends Control

@onready var level1_button: Button = $VBoxContainer/Level1Button
@onready var level2_button: Button = $VBoxContainer/Level2Button
@onready var level3_button: Button = $VBoxContainer/Level3Button
@onready var level4_button: Button = $VBoxContainer/Level4Button
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready() -> void:
	# Connect buttons
	level1_button.pressed.connect(_on_level1_pressed)
	level2_button.pressed.connect(_on_level2_pressed)
	level3_button.pressed.connect(_on_level3_pressed)
	level4_button.pressed.connect(_on_level4_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	# Update button states based on unlocked levels
	update_button_states()

func update_button_states() -> void:
	if has_node("/root/SaveManager"):
		var save_mgr = get_node("/root/SaveManager")
		
		print("[LevelSelection] Current unlocked levels: ", save_mgr.unlocked_levels)
		
		# Level 1 is always unlocked
		level1_button.disabled = false
		level1_button.text = "LEVEL 1"
		
		# Level 2 - check if unlocked
		if save_mgr.is_level_unlocked(2):
			level2_button.disabled = false
			level2_button.text = "LEVEL 2"
			print("[LevelSelection] Level 2 UNLOCKED")
		else:
			level2_button.disabled = true
			level2_button.text = "LEVEL 2 🔒"
			print("[LevelSelection] Level 2 LOCKED")
		
		# Level 3 - check if unlocked
		if save_mgr.is_level_unlocked(3):
			level3_button.disabled = false
			level3_button.text = "LEVEL 3"
			print("[LevelSelection] Level 3 UNLOCKED")
		else:
			level3_button.disabled = true
			level3_button.text = "LEVEL 3 🔒"
			print("[LevelSelection] Level 3 LOCKED")
		
		# Level 4 - check if unlocked
		if save_mgr.is_level_unlocked(4):
			level4_button.disabled = false
			level4_button.text = "LEVEL 4"
			print("[LevelSelection] Level 4 UNLOCKED")
		else:
			level4_button.disabled = true
			level4_button.text = "LEVEL 4 🔒"
			print("[LevelSelection] Level 4 LOCKED")

func _on_level1_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_level2_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_2.tscn")

func _on_level3_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_3.tscn")

func _on_level4_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_4.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/StartMenu.tscn")
