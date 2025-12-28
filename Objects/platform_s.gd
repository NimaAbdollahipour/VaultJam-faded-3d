@tool
extends StaticBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var platform_color: String = "Blue":
	set(value):
		platform_color = value
		if is_node_ready():
			update_scifi_material()

@export var fade_rate: float = 0.33 # Slower fading (takes ~3 seconds)

@onready var mesh: MeshInstance3D = $MeshInstance3D

const NEON_COLORS = {
	"Blue": Color(0.0, 1.0, 1.0),
	"Green": Color(0.2, 1.0, 0.2),
	"Red": Color(1.0, 0.2, 0.2),
	"Purple": Color(0.8, 0.2, 1.0),
	"Yellow": Color(1.0, 1.0, 0.0),
	"Orange": Color(1.0, 0.6, 0.0),
	"Gold": Color(1.0, 0.84, 0.0)
}

func _ready() -> void:
	if mesh:
		mesh.visible = true
	update_scifi_material()

func update_scifi_material() -> void:
	if not mesh: return
	
	var mat: StandardMaterial3D
	if mesh.material_override:
		mat = mesh.material_override
	else:
		mat = StandardMaterial3D.new()
		mesh.material_override = mat
	
	var target_color = NEON_COLORS.get(platform_color, Color(platform_color))
	
	# Sci-Fi / Metallic Settings
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = target_color
	mat.metallic = 1.0
	mat.metallic_specular = 1.0
	mat.roughness = 0.2
	
	# Emission (Glowing) Settings
	mat.emission_enabled = true
	mat.emission = target_color
	mat.emission_energy_multiplier = 2.0 # High intensity glow
	mat.emission_operator = BaseMaterial3D.EMISSION_OP_ADD # Full solid glow additive

func fade(delta: float) -> void:
	if not mesh: return
	
	if mesh.material_override:
		var color = mesh.material_override.albedo_color
		color.a = move_toward(color.a, 0.0, fade_rate * delta)
		mesh.material_override.albedo_color = color
		
		# Fade emission
		if mesh.material_override.emission_enabled:
			mesh.material_override.emission_energy_multiplier = color.a * 2.0
		
		if color.a <= 0.0:
			queue_free()
