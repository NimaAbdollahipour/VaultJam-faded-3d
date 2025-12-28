@tool
extends StaticBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var switcher_color: String = "Blue":
	set(value):
		switcher_color = value
		if is_node_ready():
			update_visuals()

@export var highlight_intensity: float = 5.0

@onready var area_3d: Area3D = $Area3D
@onready var light: OmniLight3D = $SpotHighlight if has_node("SpotHighlight") else null

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
	update_visuals()
	if not Engine.is_editor_hint():
		if area_3d and not area_3d.body_entered.is_connected(_on_body_entered):
			area_3d.body_entered.connect(_on_body_entered)

func update_visuals() -> void:
	var target_color = NEON_COLORS.get(switcher_color, Color(switcher_color))
	
	# Update the light highlight
	if light:
		light.light_color = target_color
		light.light_energy = highlight_intensity
	
	# Color the ColorIdentifier mesh
	var color_id = get_node_or_null("ColorIdentifier")
	if color_id and color_id is MeshInstance3D:
		var mat: StandardMaterial3D
		if color_id.material_override and color_id.material_override is StandardMaterial3D:
			mat = color_id.material_override
		else:
			mat = StandardMaterial3D.new()
			color_id.material_override = mat
		
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color = target_color
		mat.emission_enabled = true
		mat.emission = target_color
		mat.emission_energy_multiplier = 2.0
		mat.emission_operator = BaseMaterial3D.EMISSION_OP_ADD
		print("[COLOR_SWITCHER] ✓ Applied color to ColorIdentifier: ", target_color)
	else:
		print("[COLOR_SWITCHER] ⚠ ColorIdentifier mesh not found!")
	
	# Clear overrides on the GLB model to preserve original textures
	var glb_model = get_node_or_null("ColorChanger")
	if glb_model:
		_clear_overrides_recursive(glb_model)

func _clear_overrides_recursive(node: Node) -> void:
	if node is MeshInstance3D:
		node.material_override = null
	for child in node.get_children():
		_clear_overrides_recursive(child)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("change_color"):
		print("Switching color to: ", switcher_color)
		body.change_color(switcher_color)
