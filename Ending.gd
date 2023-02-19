extends Control

onready var animation_player := $AnimationPlayer

func on_ending_done():
	get_tree().change_scene("res://MainMenu.tscn")

func _ready():
	animation_player.play("Ending")
