extends Control

const intro_music = preload("res://Assets/Music/intro.mp3")

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
onready var animation_player := $AnimationPlayer
onready var audio_stream_player := $AudioStreamPlayer
onready var music_timer := $MusicTimer

var started := false

func _ready():
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	connect("gui_input", self, "on_mouse_input")
	animation_player.play("Intro")
	music_timer.connect("timeout", self, "on_ready_for_music")

func on_ready_for_music():
	audio_stream_player.stream = intro_music
	audio_stream_player.play()

func on_intro_done():
	get_tree().change_scene("res://MainMenu.tscn")

func on_mouse_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		animation_player.play("Outro")
