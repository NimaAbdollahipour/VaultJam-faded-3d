extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var theme_resource: AudioStream

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
	
	# Load Music
	if FileAccess.file_exists("res://assets/theme.mp3"):
		theme_resource = load("res://assets/theme.mp3")
		music_player.stream = theme_resource

	# Preload SFX
	for key in SFX_FILES:
		var path = SFX_FILES[key]
		if FileAccess.file_exists(path):
			sfx_resources[key] = load(path)
		else:
			print("SFX missing: ", path)

func play_music() -> void:
	if music_player.stream and not music_player.playing:
		music_player.play()

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
