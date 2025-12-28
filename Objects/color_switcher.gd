@tool
extends Node3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var switcher_color: String = "Blue":
	set(value):
		switcher_color = value
		if is_node_ready():
			update_scifi_material()

@onready var mesh: MeshInstance3D = $ColorIdentifier if has_node("ColorIdentifier") else $MeshInstance3D
@onready var area_3d: Area3D = $Area3D

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
	update_scifi_material()
	if not Engine.is_editor_hint():
		if area_3d and not area_3d.body_entered.is_connected(_on_body_entered):
			area_3d.body_entered.connect(_on_body_entered)

func update_scifi_material() -> void:
	if not mesh: return
	
	var mat: StandardMaterial3D
	if mesh.material_override:
		mat = mesh.material_override
	else:
		mat = StandardMaterial3D.new()
		mesh.material_override = mat
	
	var target_color = NEON_COLORS.get(switcher_color, Color(switcher_color))
	target_color.a = 0.75 # 75% opacity
	
	# Load texture with fallback
	var texture_path = "res://assets/tech_pattern.jpg"
	var tech_texture = null
	if FileAccess.file_exists(texture_path):
		tech_texture = load(texture_path)
		if not tech_texture:
			var img = Image.new()
			if img.load(texture_path) == OK:
				tech_texture = ImageTexture.create_from_image(img)

	# Sci-Fi Settings
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = target_color
	mat.albedo_texture = tech_texture
	mat.metallic = 1.0
	mat.metallic_specular = 1.0
	mat.roughness = 0.2
	
	# UV Tiling for tech pattern
	mat.uv1_triplanar = true
	mat.uv1_scale = Vector3(1.0, 1.0, 1.0)
	
	# Emission Settings
	mat.emission_enabled = true
	mat.emission = target_color
	mat.emission_energy_multiplier = 2.0
	mat.emission_texture = tech_texture
	mat.emission_operator = BaseMaterial3D.EMISSION_OP_MULTIPLY

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("change_color"):
		print("Switching color to: ", switcher_color)
		body.change_color(switcher_color)
