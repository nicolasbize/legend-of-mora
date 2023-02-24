extends Control

onready var new_game_button := $TextureRect/NewGameButton
onready var intro_button := $TextureRect/IntroButton
onready var quit_button := $TextureRect/QuitButton
onready var animation_player := $AnimationPlayer

var next_scene 

func _ready():
	quit_button.connect("pressed", self, "_on_quit_press")
	intro_button.connect("pressed", self, "_on_intro_press")
	new_game_button.connect("pressed", self, "_on_new_game_press")

func _on_intro_press():
	next_scene = "res://Intro.tscn"
	animation_player.play("TransionScene")

func _on_quit_press():
	get_tree().quit()

func _on_new_game_press():
	next_scene = "res://World.tscn"
	animation_player.play("TransionScene")

func on_transition_complete():
	get_tree().change_scene(next_scene)
