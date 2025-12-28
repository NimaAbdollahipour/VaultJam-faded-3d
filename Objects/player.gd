@tool
extends CharacterBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange", "Gold") var player_color: String = "Blue":
	set(value):
		player_color = value
		if is_node_ready():
			update_scifi_material(value)

@export var fade_rate: float = 0.1
@export var push_force: float = 5.0

const SPEED = 5.0
const JUMP_VELOCITY = 9
const BALL_RADIUS = 0.5

var mesh: MeshInstance3D  # Set in _ready() from found meshes
var visual_meshes: Array[MeshInstance3D] = []

var is_safe: bool = false
var was_on_floor: bool = false
var push_cooldown: float = 0.0
const PUSH_INTERVAL: float = 0.5
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
	# Gather all visual meshes recursively (in case of imported scenes)
	visual_meshes.clear()
	_find_meshes_recursive(self, visual_meshes)

	axis_lock_linear_z = true
	
	# If the specific nodes aren't found, use the first visual mesh as the primary 'mesh'
	if not mesh and visual_meshes.size() > 0:
		mesh = visual_meshes[0]
	
	update_scifi_material(player_color)

func _find_meshes_recursive(node: Node, list: Array[MeshInstance3D]) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			list.append(child)
			print("[PLAYER] Found MeshInstance3D: ", child.name)
		# Always recurse into children to find nested meshes
		_find_meshes_recursive(child, list)

var is_on_matching_platform: bool = false

func _process(delta: float) -> void:
	# Get current alpha from the main mesh tracking variable
	# We'll use the material of the first visual mesh to keep them in sync
	var first_mat = null
	if visual_meshes.size() > 0:
		first_mat = visual_meshes[0].material_override
	
	if not first_mat: return
	
	var current_alpha = first_mat.albedo_color.a
	var target_alpha = 1.0
	
	# NEW LOGIC: Player fades if they ARE on a matching platform
	if is_on_matching_platform:
		target_alpha = 0.0
	
	var new_alpha = move_toward(current_alpha, target_alpha, fade_rate * delta)
	
	# Apply to ALL visual meshes
	for vm in visual_meshes:
		var mat = vm.material_override
		if mat:
			var col = mat.albedo_color
			col.a = new_alpha
			mat.albedo_color = col
			
			if mat.emission_enabled:
				mat.emission_energy_multiplier = new_alpha * 2.0
	
	# Game Over if player fades out completely
	if new_alpha <= 0.0:
		print("Game Over: Player Faded")
		get_tree().call_group("GameManager", "game_over")
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("lose")
		set_process(false)
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Update push cooldown
	if push_cooldown > 0:
		push_cooldown -= delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("jump")

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.z = 0

	# Rotate ALL meshes to simulate rolling
	if velocity.x != 0:
		# Standard Ball Roll: omega = v / r
		var rot_amount = (-velocity.x / BALL_RADIUS) * delta
		for vm in visual_meshes:
			vm.rotate_z(rot_amount)

	move_and_slide()
	
	# Landing Sound
	if not was_on_floor and is_on_floor():
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("land")
	
	was_on_floor = is_on_floor()
	
	# Check for Game Over (Fall off)
	if global_position.y < -10.0:
		print("Game Over")
		get_tree().call_group("GameManager", "game_over")
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("lose")
		set_process(false)
		set_physics_process(false)
	
	# Platform Interaction Logic
	is_on_matching_platform = false # Reset state
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Check if the collider is a platform
		if collider.has_method("fade") and "platform_color" in collider:
			if collider.platform_color == player_color:
				# MATCH: Player starts fading, platform is stable
				is_on_matching_platform = true
			else:
				# NO MATCH: Platform fades away
				collider.fade(delta)
				
		# Check for Box Pushing
		if collider is RigidBody3D and "box_color" in collider:
			if collider.box_color == player_color:
				var push_dir = -collision.get_normal()
				push_dir.y = 0
				push_dir = push_dir.normalized()
				collider.apply_central_impulse(push_dir * push_force * delta)
				
				if push_cooldown <= 0:
					if has_node("/root/AudioManager"):
						get_node("/root/AudioManager").play_sfx("push")
					push_cooldown = PUSH_INTERVAL

# Called by ColorSwitcher
func change_color(new_color: String) -> void:
	player_color = new_color
	
	# Reset Player Alpha immediately on color change
	for vm in visual_meshes:
		if vm.material_override:
			var col = vm.material_override.albedo_color
			col.a = 1.0
			vm.material_override.albedo_color = col
			if vm.material_override.emission_enabled:
				vm.material_override.emission_energy_multiplier = 2.0
	
	update_scifi_material(new_color)
	
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("change_color")

func update_scifi_material(color_name: String) -> void:
	# Apply game color to ColorIdentifier mesh
	var target_color = NEON_COLORS.get(color_name, Color(color_name))
	print("[PLAYER] Updating ColorIdentifier to color: ", color_name, " -> ", target_color)
	
	for vm in visual_meshes:
		if vm.name == "ColorIdentifier":
			print("[PLAYER] Found ColorIdentifier mesh!")
			# Apply color with emission
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
			mat.emission_energy_multiplier = 3.0
			mat.emission_operator = BaseMaterial3D.EMISSION_OP_ADD
			print("[PLAYER] ✓ Applied color to ColorIdentifier")
			return
	
	print("[PLAYER] ⚠ ColorIdentifier mesh not found!")
