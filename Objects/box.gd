extends RigidBody3D

@export_enum("Blue", "Green", "Red", "Purple", "Orange") var box_color: String = "Blue"

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(box_color)
	mesh.material_override = mat
	
	# Initial mass setup, though interactions will mainly be handled by Player
	# We'll allow the physics engine to handle general collisions, 
	# but Player will only forcefully push if colors match.
	# To make "immovable" by player push otherwise, we rely on the Player script not applying impulse.
	# However, standard physics collisions will still occur.
	# If the user means "pass through" vs "push", that's different.
	# "Player can push" implies standard collision otherwise acts as a wall.
	# This is default behavior for RigidBody vs CharacterBody (CharacterBody slides off RigidBody).
