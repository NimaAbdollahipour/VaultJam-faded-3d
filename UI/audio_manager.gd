extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var menu_music_resource: AudioStream
var game_music_resource: AudioStream

# SFX Cache
var sfx_resources = {}
const SFX_FILES = {
	"jump": "res://assets/jump.wav",
	"land": "res://assets/land.wav",
	"win": "res://assets/win.wav",
	"lose": "res://assets/lose.wav",
	"push": "res://assets/push.wav",
	"change_color": "res://assets/change_color.wav"
}

func _ready() -> void:
	# Music Player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Master"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	
	# SFX Player
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Master"
	sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sfx_player)
	
	# Load Menu Music (theme.mp3)
	if FileAccess.file_exists("res://assets/theme.mp3"):
		menu_music_resource = load("res://assets/theme.mp3")
		if menu_music_resource:
			if menu_music_resource is AudioStreamMP3:
				menu_music_resource.loop = true
			print("[AudioManager] Menu music loaded successfully")
		else:
			print("[AudioManager] Failed to load theme.mp3")
	else:
		print("[AudioManager] theme.mp3 file not found")
	
	# Load Game Music (Background.mp3)
	if FileAccess.file_exists("res://assets/Background.mp3"):
		game_music_resource = load("res://assets/Background.mp3")
		if game_music_resource:
			if game_music_resource is AudioStreamMP3:
				game_music_resource.loop = true
			print("[AudioManager] Game music loaded successfully")
		else:
			print("[AudioManager] Failed to load Background.mp3")
	else:
		print("[AudioManager] Background.mp3 file not found")

	# Preload SFX
	for key in SFX_FILES:
		var path = SFX_FILES[key]
		if FileAccess.file_exists(path):
			sfx_resources[key] = load(path)
		else:
			print("SFX missing: ", path)

func play_menu_music() -> void:
	if menu_music_resource:
		if music_player.stream != menu_music_resource:
			music_player.stream = menu_music_resource
			music_player.volume_db = 0
		if not music_player.playing:
			music_player.play()

func play_game_music() -> void:
	if game_music_resource:
		if music_player.stream != game_music_resource:
			music_player.stream = game_music_resource
			music_player.volume_db = 0
		if not music_player.playing:
			music_player.play()

func play_music() -> void:
	# Legacy function - defaults to game music
	play_game_music()

func stop_music() -> void:
	if music_player.playing:
		music_player.stop()

func pause_music() -> void:
	if music_player.playing:
		music_player.stream_paused = true

func resume_music() -> void:
	if music_player.stream_paused:
		music_player.stream_paused = false
	elif not music_player.playing:
		music_player.play()

func play_sfx(sfx_name: String) -> void:
	if sfx_resources.has(sfx_name):
		# Create a temporary player for overlapping sounds if needed, 
		# or just use sfx_player if one at a time is fine. 
		# For gameplay, overlapping is better.
		var player = AudioStreamPlayer.new()
		player.stream = sfx_resources[sfx_name]
		player.bus = "Master"
		add_child(player)
		player.finished.connect(player.queue_free)
		player.play()
