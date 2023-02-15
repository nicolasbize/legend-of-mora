extends Node

onready var transition_animation_player = $"Game UI/TransitionAnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.in_town:
		transition_animation_player.play("EnterTown")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
