@tool
extends RigidBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var box_color: String = "Blue":
	set(value):
		box_color = value
		if is_node_ready():
			update_scifi_material()

var visual_meshes: Array[MeshInstance3D] = []

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
	visual_meshes.clear()
	_find_meshes_recursive(self, visual_meshes)
	update_scifi_material()

func _find_meshes_recursive(node: Node, list: Array[MeshInstance3D]) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			list.append(child)
		_find_meshes_recursive(child, list)

func update_scifi_material() -> void:
	var target_color = NEON_COLORS.get(box_color, Color(box_color))
	
	for vm in visual_meshes:
		var mat: StandardMaterial3D
		if vm.material_override:
			mat = vm.material_override
		else:
			mat = StandardMaterial3D.new()
			vm.material_override = mat
		
		# Sci-Fi / Metallic Settings
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color = target_color
		mat.metallic = 1.0
		mat.metallic_specular = 1.0
		mat.roughness = 0.2
		
		# Emission Settings
		mat.emission_enabled = true
		mat.emission = target_color
		mat.emission_energy_multiplier = 2.0
		mat.emission_operator = BaseMaterial3D.EMISSION_OP_ADD
