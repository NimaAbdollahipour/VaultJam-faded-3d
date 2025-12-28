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

@onready var mesh: MeshInstance3D = $ColorIdentifier if has_node("ColorIdentifier") else $MeshInstance3D
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
	
	# Prepare all meshes for fading
	for vm in visual_meshes:
		if vm.visible:
			vm.visible = false # Hide initially for pop-in fix
			
		# Ensure every mesh has a material override we can fade
		if not vm.material_override:
			# If it has a surface material, clone it. Else create new.
			var source_mat = vm.get_active_material(0)
			var new_mat: StandardMaterial3D
			
			if source_mat is StandardMaterial3D:
				new_mat = source_mat.duplicate()
			else:
				new_mat = StandardMaterial3D.new()
				# Try to preserve color if possible, though tough for plain BaseMaterial
				if source_mat and "albedo_color" in source_mat:
					new_mat.albedo_color = source_mat.albedo_color
			
			# Force transparency for fading
			new_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			vm.material_override = new_mat
		else:
			# Existing override, just ensure it handles transparency
			if vm.material_override.transparency != BaseMaterial3D.TRANSPARENCY_ALPHA:
				vm.material_override.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

	axis_lock_linear_z = true
	update_scifi_material(player_color)
	
	await get_tree().process_frame
	for vm in visual_meshes:
		vm.visible = true

func _find_meshes_recursive(node: Node, list: Array[MeshInstance3D]) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			list.append(child)
		_find_meshes_recursive(child, list)

func _process(delta: float) -> void:
	# Handle Fading for ALL visual meshes
	var current_alpha = 1.0
	
	# We use the main color identifier mesh to track state if possible
	if mesh and mesh.material_override:
		current_alpha = mesh.material_override.albedo_color.a
	elif visual_meshes.size() > 0 and visual_meshes[0].material_override:
		# Fallback if specific identifier missing
		current_alpha = visual_meshes[0].material_override.albedo_color.a
	
	var target_alpha = 0.0
	if is_safe:
		target_alpha = 1.0
	
	var new_alpha = move_toward(current_alpha, target_alpha, fade_rate * delta)
	
	for vm in visual_meshes:
		var mat = vm.material_override
		if mat:
			var col = mat.albedo_color
			col.a = new_alpha
			mat.albedo_color = col
			
			if mat.emission_enabled:
				mat.emission_energy_multiplier = new_alpha * 2.0
	
	# Check for Game Over (Fade out) using new_alpha
	if new_alpha <= 0.0:
		print("Game Over")
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
	
	is_safe = false
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		# Check if the collider is a platform with matching color
		if collider.has_method("fade") and "platform_color" in collider:
			if collider.platform_color == player_color:
				is_safe = true
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
	update_scifi_material(new_color)
	
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("change_color")

func update_scifi_material(color_name: String) -> void:
	if not mesh: return

	# Create or reuse material
	var mat: StandardMaterial3D
	if mesh.material_override:
		mat = mesh.material_override
	else:
		mat = StandardMaterial3D.new()
		mesh.material_override = mat
	
	var target_color = NEON_COLORS.get(color_name, Color(color_name))
	
	# Load texture
	var texture_path = "res://assets/tech_pattern.jpg"
	var tech_texture = null
	
	if FileAccess.file_exists(texture_path):
		# Try standard resource load first
		tech_texture = load(texture_path)
		
		# Fallback: If resource load fails (e.g. import issue), load raw image
		if not tech_texture:
			print("Resource load failed, trying raw image load...")
			var img = Image.new()
			var err = img.load(texture_path)
			if err == OK:
				tech_texture = ImageTexture.create_from_image(img)
			else:
				print("Failed to load raw image: ", err)
	else:
		print("Texture file not found at: ", texture_path)
	
	# Sci-Fi / Metallic Settings
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = target_color
	mat.albedo_texture = tech_texture
	mat.metallic = 1.0
	mat.metallic_specular = 1.0
	mat.roughness = 0.2
	
	# UV Tiling for tech pattern
	mat.uv1_triplanar = true
	mat.uv1_scale = Vector3(1.0, 1.0, 1.0)
	
	# Emission (Glowing) Settings
	mat.emission_enabled = true
	mat.emission = target_color
	mat.emission_energy_multiplier = 2.0 # High intensity glow
	mat.emission_texture = tech_texture
	mat.emission_operator = BaseMaterial3D.EMISSION_OP_MULTIPLY # Use texture to mask emission
