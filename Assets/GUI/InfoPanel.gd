extends Control

onready var return_button = $Background/ReturnButton

export(NodePath) var transition_animation_path = null
export(NodePath) var player_path = null

var transition_animation = null
var player = null

func _ready():
	player = get_node(player_path)
	transition_animation = get_node(transition_animation_path)
	return_button.connect("pressed", self, "on_return_button")
	
func on_return_button():
	print("needs implementation")

func refresh():
	print("needs implementation")
