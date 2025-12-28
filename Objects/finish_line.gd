extends StaticBody3D

@onready var area_3d: Area3D = $Area3D

func _ready() -> void:
	area_3d.body_entered.connect(_on_area_3d_body_entered)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" or body.has_method("get_input_axis"): # Duck typing check for player

		get_tree().call_group("GameManager", "level_complete")
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("win")
