extends StaticBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange") var platform_color: String = "Blue"
@export var fade_rate: float = 0.5

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(platform_color)
	mesh.material_override = mat

# Called by the player when they are standing on this platform
func fade(delta: float) -> void:
	if mesh.material_override:
		var color = mesh.material_override.albedo_color
		color.a = move_toward(color.a, 0.0, fade_rate * delta)
		mesh.material_override.albedo_color = color
		
		if color.a <= 0.0:
			queue_free()
