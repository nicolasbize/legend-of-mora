extends Control

const intro_music = preload("res://Assets/Music/intro.mp3")

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
onready var animation_player := $AnimationPlayer
onready var audio_stream_player := $AudioStreamPlayer
onready var music_timer := $MusicTimer
onready var sound_button := $SoundButton

var started := false
var start_time_ms := 0

func _ready():
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	connect("gui_input", self, "on_mouse_input")
	sound_button.connect("pressed", self, "on_sound_press")
	animation_player.play("Intro")
	music_timer.connect("timeout", self, "on_ready_for_music")
	start_time_ms = OS.get_ticks_msec()

func on_ready_for_music():
	audio_stream_player.stream = intro_music
	audio_stream_player.play()

func on_intro_done():
	get_tree().change_scene("res://MainMenu.tscn")

func on_mouse_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var elapsed_ms:float = OS.get_ticks_msec() - start_time_ms as float
		# prevent premature skips
		if elapsed_ms > 4000:
			animation_player.play("Outro")
		
func on_sound_press():
	GameState.is_audio_enabled = !GameState.is_audio_enabled
	sound_button.pressed = GameState.is_audio_enabled
	if GameState.is_audio_enabled:
		audio_stream_player.volume_db = -5
	else:
		audio_stream_player.volume_db = -100
