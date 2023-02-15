extends Node2D

onready var score = $Score

func set_text(text):
	score.text = text
	
func finish_animation():
	call_deferred("queue_free")
