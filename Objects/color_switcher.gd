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
	
	# Instead of coloring the mesh, we use a light to "highlight" it like sunlight
	if light:
		light.light_color = target_color
		light.light_energy = highlight_intensity
	
	# Clear any material overrides to show the model's natural texture colors
	_clear_overrides_recursive(self)

func _clear_overrides_recursive(node: Node) -> void:
	if node is MeshInstance3D:
		node.material_override = null
	for child in node.get_children():
		_clear_overrides_recursive(child)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("change_color"):
		print("Switching color to: ", switcher_color)
		body.change_color(switcher_color)
