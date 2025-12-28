@tool
extends StaticBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var platform_color: String = "Blue":
	set(value):
		platform_color = value
		if is_node_ready():
			update_visuals()

@export_enum("When Standing", "Always") var fade_mode: String = "When Standing"
@export var fade_rate: float = 1.0

@onready var mesh: MeshInstance3D = $MeshInstance3D if has_node("MeshInstance3D") else null
var visual_meshes: Array[MeshInstance3D] = []

const NEON_COLORS = {
	"Blue": Color(0.0, 0.5, 1.0),
	"Green": Color(0.2, 0.8, 0.2),
	"Red": Color(1.0, 0.2, 0.2),
	"Purple": Color(0.6, 0.2, 0.8),
	"Yellow": Color(1.0, 1.0, 0.0),
	"Orange": Color(1.0, 0.6, 0.0),
	"Gold": Color(1.0, 0.84, 0.0)
}

func _ready() -> void:
	visual_meshes.clear()
	_find_meshes_recursive(self, visual_meshes)
	update_visuals()

func _find_meshes_recursive(node: Node, list: Array[MeshInstance3D]) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			list.append(child)
		_find_meshes_recursive(child, list)

func update_visuals() -> void:
	# Apply game color with tech_pattern texture
	var target_color = NEON_COLORS.get(platform_color, Color(platform_color))
	print("[PLATFORM] Updating platform color to: ", platform_color, " -> ", target_color)
	
	# Load tech_pattern texture
	var tech_texture: Texture2D = null
	if FileAccess.file_exists("res://assets/tech_pattern.jpg"):
		tech_texture = load("res://assets/tech_pattern.jpg")
	elif FileAccess.file_exists("res://assets/tech_pattern.png"):
		tech_texture = load("res://assets/tech_pattern.png")
	
	for vm in visual_meshes:
		# Apply color with tech_pattern texture
		var mat: StandardMaterial3D
		if vm.material_override and vm.material_override is StandardMaterial3D:
			mat = vm.material_override
		else:
			mat = StandardMaterial3D.new()
			vm.material_override = mat
		
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		
		# Apply tech_pattern texture if available
		if tech_texture:
			mat.albedo_texture = tech_texture
			mat.uv1_triplanar = true
			mat.uv1_scale = Vector3(0.5, 0.5, 0.5)
		
		# Tint the texture with game color (less intense)
		mat.albedo_color = Color(target_color.r, target_color.g, target_color.b, 1.0)
		
		# No emission glow
		mat.emission_enabled = true
		mat.emission = target_color
		mat.emission_energy_multiplier = 0.0  # No glow
		mat.emission_operator = BaseMaterial3D.EMISSION_OP_ADD
	
	print("[PLATFORM] Applied colored tech_pattern to ", visual_meshes.size(), " meshes")

func fade(delta: float) -> void:
	var fully_faded = true
	
	for vm in visual_meshes:
		if vm.material_override:
			var color = vm.material_override.albedo_color
			color.a = move_toward(color.a, 0.0, fade_rate * delta)
			vm.material_override.albedo_color = color
			
			if vm.material_override.emission_enabled:
				vm.material_override.emission_energy_multiplier = color.a
				
			if color.a > 0.0:
				fully_faded = false
	
	if fully_faded:
		queue_free()
