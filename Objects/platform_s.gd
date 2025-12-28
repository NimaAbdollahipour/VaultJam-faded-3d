@tool
extends StaticBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var platform_color: String = "Blue":
	set(value):
		platform_color = value
		if is_node_ready():
			update_visuals()

@export var fade_rate: float = 0.33

@onready var mesh: MeshInstance3D = $MeshInstance3D if has_node("MeshInstance3D") else null
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
	update_visuals()

func _find_meshes_recursive(node: Node, list: Array[MeshInstance3D]) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			list.append(child)
		_find_meshes_recursive(child, list)

func update_visuals() -> void:
	# Do nothing - preserve original materials completely
	pass

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
