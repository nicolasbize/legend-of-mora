extends Control

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
onready var animation_player := $AnimationPlayer
onready var audio_stream_player := $AudioStreamPlayer

func _ready():
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	connect("gui_input", self, "on_mouse_input")
	animation_player.play("Intro")

func on_intro_done():
	get_tree().change_scene("res://MainMenu.tscn")

func on_mouse_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		animation_player.play("Outro")
