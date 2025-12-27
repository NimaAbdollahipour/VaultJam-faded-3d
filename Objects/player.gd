extends CharacterBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange") var player_color: String = "Blue"
@export var fade_rate: float = 0.1
@export var push_force: float = 5.0

const SPEED = 5.0
const JUMP_VELOCITY = 9
const BALL_RADIUS = 0.5

@onready var mesh: MeshInstance3D = $MeshInstance3D

var is_safe: bool = false

func _ready() -> void:
	axis_lock_linear_z = true
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(player_color)
	mesh.material_override = mat

func _process(delta: float) -> void:
	if mesh.material_override:
		var color = mesh.material_override.albedo_color
		
		if not is_safe:
			color.a = move_toward(color.a, 0.0, fade_rate * delta)
		else:
			# Recover opacity when safe
			color.a = move_toward(color.a, 1.0, fade_rate * delta)
			
		mesh.material_override.albedo_color = color
		
		# Check for Game Over (Fade out)
		if color.a <= 0.0:
			print("Game Over")
			get_tree().call_group("GameManager", "game_over")
			set_process(false)
			set_physics_process(false)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.z = 0

	# Rotate the mesh to simulate rolling
	if velocity.x != 0:
		mesh.rotate_z(-velocity.x / BALL_RADIUS * delta / SPEED * 2 )

	move_and_slide()
	
	# Check for Game Over (Fall off)
	if global_position.y < -10.0:
		print("Game Over")
		get_tree().call_group("GameManager", "game_over")
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

# Called by ColorSwitcher
func change_color(new_color: String) -> void:
	player_color = new_color
	if mesh.material_override:
		var color = Color(new_color)
		color.a = 1.0 # Reset opacity
		mesh.material_override.albedo_color = color
