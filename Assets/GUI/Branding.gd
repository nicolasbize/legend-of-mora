extends Control

onready var video_player := $VideoPlayer

func _ready():
	if GameState.export_armor_games:
		video_player.connect("finished", self, "start_intro")
		video_player.connect("gui_input", self, "on_mouse_input")		
		video_player.play()
	else:
		start_intro()

func start_intro():
	get_tree().change_scene("res://Intro.tscn")

func on_mouse_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		OS.shell_open("https://armor.ag/MoreGames")
