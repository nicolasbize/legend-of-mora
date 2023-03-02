extends Control

onready var new_game_button := $TextureRect/NewGameButton
onready var intro_button := $TextureRect/IntroButton
onready var quit_button := $TextureRect/QuitButton
onready var animation_player := $AnimationPlayer
onready var continue_button := $TextureRect/ContinueButton

var next_scene
var continue_available := false

func _ready():
	GameState.is_loading_savegame = false
	quit_button.connect("pressed", self, "_on_quit_press")
	intro_button.connect("pressed", self, "_on_intro_press")
	new_game_button.connect("pressed", self, "_on_new_game_press")
	continue_button.connect("pressed", self, "_on_continue_press")
	var save_game = File.new()
	if not save_game.file_exists(GameState.SAVE_FILE_LOCATION):
		continue_button.disable()
	else:
		continue_available = true

func _on_continue_press():
	GameState.is_loading_savegame = true
	start_game()

func _on_intro_press():
	next_scene = "res://Intro.tscn"
	animation_player.play("TransitionScene")

func _on_quit_press():
	get_tree().quit()

func _on_new_game_press():
	if continue_available:
		print("warning, will erase previous save!")
	start_game()

func start_game():
	next_scene = "res://World.tscn"
	animation_player.play("TransitionScene")

func on_transition_complete():
	get_tree().change_scene(next_scene)
