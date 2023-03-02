extends Node2D

onready var score := $Score
onready var start_timer := $StartTimer
onready var animation_player := $AnimationPlayer

var is_green = false

func _ready():
	start_timer.connect("timeout", self, "start_animation")

func start_animation():
	if is_green: 
		animation_player.play("MoveUpGreen")
	else:
		animation_player.play("MoveUp")
	
func set_text(text):
	score.text = text

func set_green():
	score.set("custom_colors/font_color", "3bd316")
	is_green = true

func finish_animation():
	call_deferred("queue_free")
