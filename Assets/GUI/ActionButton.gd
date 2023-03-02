extends TextureButton

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
const POINTER_CURSOR = preload("res://Assets/GUI/cursor-pointer.png")
const WAIT_CURSOR = preload("res://Assets/GUI/cursor-wait.png")

onready var progress_bar := $ProgressBar
onready var animation_player := $AnimationPlayer
onready var activation_timer := $ActivationTimer
onready var skill_sprite := $SkillSprite

var hovered := false
var is_activated := false
var activating := false
var is_success_activation := false

func _ready():
	connect("mouse_entered", self, "on_mouse_enter")
	connect("mouse_exited", self, "on_mouse_exit")
	connect("pressed", self, "on_mouse_press")
	progress_bar.visible = false
	progress_bar.connect("complete", self, "on_progress_complete")
	activation_timer.connect("timeout", self, "activate")
	randomize()

func on_mouse_enter():
	hovered = true
	if not disabled:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)
	
func on_mouse_exit():
	hovered = false
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)

func on_mouse_press():
	is_success_activation = activating and is_activated

func disable_for(time, activate_before_enable = false):
	progress_bar.visible = true
	progress_bar.start_timer(time)
	disabled = true
	if hovered:
		Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	if activate_before_enable:
		activation_timer.start(time / 1000.0 - 0.2)

func cancel_activation():
	activation_timer.stop()

func on_progress_complete():
	disabled = false
	progress_bar.visible = false
	if hovered:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)

func activate(speed_activation = false):
	activating = true
	is_success_activation = false
	is_activated = false
	if speed_activation:
		animation_player.playback_speed = 1.5
	else:
		animation_player.playback_speed = 1
	animation_player.play("Activate")

func is_activated():
	return is_activated

func on_activated_animation():
	is_activated = true
	
func on_stop_activate_animation():
	if activating:
		activating = false
		is_activated = false
		if is_success_activation:
			animation_player.play("Success")
		else:
			animation_player.play("Fail")
	else:
		animation_player.play("Idle")
	
