extends Node3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange") var switcher_color: String = "Blue"

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var area_3d: Area3D = $Area3D

func _ready() -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(switcher_color)
	mesh.material_override = mat
	
	area_3d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("change_color"):
		print("Switching color to: ", switcher_color)
		body.change_color(switcher_color)
		# Optional: Visual feedback or consume the switcher?
		# For now, just keeping it persistent.
