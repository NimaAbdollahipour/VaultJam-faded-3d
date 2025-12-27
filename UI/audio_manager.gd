extends Node

var music_player: AudioStreamPlayer
var theme_resource: AudioStream

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Load the resource once
	if FileAccess.file_exists("res://assets/theme.mp3"):
		theme_resource = load("res://assets/theme.mp3")
		music_player.stream = theme_resource
		music_player.bus = "Master"
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS # Keep running so we can control it during pause

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
