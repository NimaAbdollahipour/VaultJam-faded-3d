@tool
extends RigidBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var box_color: String = "Blue":
	set(value):
		box_color = value
		if is_node_ready():
			update_visuals()

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
	
	# CRITICAL: Duplicate materials so each box instance has its own
	# This prevents changing one box's color from affecting all boxes
	for vm in visual_meshes:
		if vm.material_override:
			vm.material_override = vm.material_override.duplicate()

	update_visuals()
	print("[Box] Ready - color:", box_color)

func _find_meshes_recursive(node: Node, list: Array[MeshInstance3D]) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			list.append(child)
		_find_meshes_recursive(child, list)

func update_visuals() -> void:
	# Apply game color to ColorIdentifier mesh
	var target_color = NEON_COLORS.get(box_color, Color(box_color))
	
	for vm in visual_meshes:
		if vm.name == "ColorIdentifier":

			# Apply color without emission
			var mat: StandardMaterial3D
			if vm.material_override and vm.material_override is StandardMaterial3D:
				mat = vm.material_override
			else:
				mat = StandardMaterial3D.new()
				vm.material_override = mat
			
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			mat.albedo_color = target_color
			mat.emission_enabled = true
			mat.emission = target_color
			mat.emission_energy_multiplier = 0.0  # No glow
			mat.emission_operator = BaseMaterial3D.EMISSION_OP_ADD

			return
	



func start_fading(delta: float) -> void:
	# Safety check for delta parameter
	if delta == null:
		return
	
	# Fade all meshes including ColorIdentifier
	var fully_faded = true
	
	for vm in visual_meshes:
		if vm.material_override:
			var color = vm.material_override.albedo_color
			color.a = move_toward(color.a, 0.0, 0.5 * delta)  # Fade rate
			vm.material_override.albedo_color = color
			
			if vm.material_override.emission_enabled:
				vm.material_override.emission_energy_multiplier = color.a * 2.0
				
			if color.a > 0.0:
				fully_faded = false
	
	if fully_faded:
		queue_free()
