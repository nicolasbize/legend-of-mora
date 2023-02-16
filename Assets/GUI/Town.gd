extends Control

onready var day_label = $TextureRect/DayLabel
onready var gold_label = $TextureRect/GoldLabel
onready var dest_label = $TextureRect/DestLabel
onready var button_blacksmith = $TextureRect/ButtonBlacksmith
onready var button_armory = $TextureRect/ButtonArmory
onready var button_alchimist = $TextureRect/ButtonAlchimist
onready var button_library = $TextureRect/ButtonLibrary
onready var button_leave = $TextureRect/ButtonGo

export(NodePath) var transition_animation_path = null

var transition_animation = null

func _ready():
	if transition_animation_path != null:
		transition_animation = get_node(transition_animation_path)
	button_blacksmith.connect("pressed", self, "on_press", ["EnterBlacksmith"])
	button_armory.connect("pressed", self, "on_press", ["EnterArmory"])
	button_alchimist.connect("pressed", self, "on_press", ["EnterAlchimist"])
	button_library.connect("pressed", self, "on_press", ["EnterLibrary"])
	button_leave.connect("pressed", self, "on_press", ["LeaveTown"])

func on_press(transition):
	if transition_animation != null:
		transition_animation.play(transition)
