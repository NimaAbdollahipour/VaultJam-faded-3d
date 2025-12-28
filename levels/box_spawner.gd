extends Node3D

## Box Spawner - Continuously spawns falling boxes with fade effect
## Boxes fade out and respawn only if they didn't reach the finish line

@export var spawn_offset_y: float = 0.0
@export var despawn_y_position: float = -15.0
@export var finish_line_x_position: float = 45.0  # X position where boxes are "safe" (near finish)
@export var fade_duration: float = 1.0  # How long fade takes

var active_boxes: Array = []
var fading_boxes: Dictionary = {}  # Track boxes currently fading
var respawn_count: int = 0

func _ready() -> void:
	var level_root = get_parent()
	if level_root:
		find_initial_boxes(level_root)
	
	print("[BoxSpawner] Found ", active_boxes.size(), " boxes to manage")
	print("[BoxSpawner] Finish line safety zone at X >= ", finish_line_x_position)

func find_initial_boxes(node: Node) -> void:
	for child in node.get_children():
		if child == self:
			continue
			
		if child is RigidBody3D and "box_color" in child:
			var box_data = {
				"box": child,
				"initial_position": child.global_position,
				"initial_rotation": child.global_rotation,
				"initial_color": child.box_color,
				"reached_end": false  # Track if box reached finish
			}
			active_boxes.append(box_data)
		
		find_initial_boxes(child)

func _process(delta: float) -> void:
	# Update fading boxes
	var fade_keys = fading_boxes.keys()
	for box_id in fade_keys:
		var fade_data = fading_boxes[box_id]
		fade_data.timer += delta
		
		# Calculate fade alpha (1.0 -> 0.0)
		var fade_progress = fade_data.timer / fade_duration
		var alpha = 1.0 - fade_progress
		
		# Apply fade to box materials
		apply_fade_to_box(fade_data.box, alpha)
		
		# When fade complete, respawn
		if fade_progress >= 1.0:
			respawn_box(fade_data.box_data)
			fading_boxes.erase(box_id)
	
	# Check boxes for fall/success
	for box_data in active_boxes:
		var box = box_data["box"]
		
		if not box or not is_instance_valid(box):
			continue
		
		# Skip if already fading or reached end
		if fading_boxes.has(box.get_instance_id()) or box_data.reached_end:
			continue
		
		# Check if box reached finish line area (success!)
		if box.global_position.x >= finish_line_x_position:
			box_data.reached_end = true
			print("[BoxSpawner] Box reached finish line! Won't respawn.")
			continue
		
		# Check if box fell below threshold
		if box.global_position.y < despawn_y_position:
			# Start fading
			start_fade(box, box_data)

func start_fade(box: RigidBody3D, box_data: Dictionary) -> void:
	var box_id = box.get_instance_id()
	
	# Freeze box during fade to prevent weird physics
	box.freeze = true
	
	fading_boxes[box_id] = {
		"box": box,
		"box_data": box_data,
		"timer": 0.0
	}
	print("[BoxSpawner] Box started fading...")

func apply_fade_to_box(box: RigidBody3D, alpha: float) -> void:
	# Find all mesh instances in box and fade their materials
	fade_meshes_recursive(box, alpha)

func fade_meshes_recursive(node: Node, alpha: float) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			var mesh = child as MeshInstance3D
			if mesh.material_override:
				var mat = mesh.material_override
				var color = mat.albedo_color
				color.a = alpha
				mat.albedo_color = color
				
				if mat.emission_enabled:
					mat.emission_energy_multiplier = alpha
		
		fade_meshes_recursive(child, alpha)

func respawn_box(box_data: Dictionary) -> void:
	var box = box_data["box"]
	
	if not box or not is_instance_valid(box):
		return
	
	# Temporarily freeze physics during teleport to prevent bugs
	box.freeze = true
	
	# Reset position and physics
	box.global_position = box_data["initial_position"]
	box.global_position.y += spawn_offset_y
	box.global_rotation = box_data["initial_rotation"]
	box.linear_velocity = Vector3.ZERO
	box.angular_velocity = Vector3.ZERO
	
	# Restore full opacity
	apply_fade_to_box(box, 1.0)
	
	# Wait one frame then unfreeze
	await get_tree().process_frame
	box.freeze = false
	box.sleeping = false
	
	respawn_count += 1
	print("[BoxSpawner] Respawned box #", respawn_count, " at Y=", box.global_position.y)
