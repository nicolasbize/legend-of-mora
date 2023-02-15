extends Control

onready var day_label = $TextureRect/DayLabel
onready var gold_label = $TextureRect/GoldLabel
onready var dest_label = $TextureRect/DestLabel
onready var button_blacksmith = $TextureRect/ButtonBlacksmith
onready var button_alchimist = $TextureRect/ButtonAlchimist
onready var button_library = $TextureRect/ButtonLibrary

export(NodePath) var transition_animation_path = null

var transition_animation = null

func _ready():
	if transition_animation_path != null:
		transition_animation = get_node(transition_animation_path)
	button_blacksmith.connect("pressed", self, "on_blacksmith_press")

func on_blacksmith_press():
	print("p[ressed]")
	if transition_animation != null:
		transition_animation.play("EnterBlacksmith")
