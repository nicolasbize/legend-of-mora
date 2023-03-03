extends TextureButton

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
const POINTER_CURSOR = preload("res://Assets/GUI/cursor-pointer.png")
const WAIT_CURSOR = preload("res://Assets/GUI/cursor-wait.png")

onready var progress_bar := $ProgressBar
onready var animation_player := $AnimationPlayer
onready var skill_sprite := $SkillSprite

export(float) var reflex_time_msec = 400
export(bool) var can_activate := false

var hovered := false
var is_activated := false
var is_success_activation := false
var activation_start_time = OS.get_ticks_msec()

func _ready():
	connect("mouse_entered", self, "on_mouse_enter")
	connect("mouse_exited", self, "on_mouse_exit")
	connect("pressed", self, "on_mouse_press")
	progress_bar.visible = false
	progress_bar.connect("complete", self, "on_progress_complete")
	randomize()

func _process(delta):
	if can_activate and is_activated and OS.get_ticks_msec() - activation_start_time > reflex_time_msec:
		is_success_activation = false
		is_activated = false
		animation_player.play("Fail")
		
func on_mouse_enter():
	hovered = true
	if not disabled:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)
	
func on_mouse_exit():
	hovered = false
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)

func on_mouse_press():
	if can_activate and is_activated:
		is_activated = false
		is_success_activation = true
		animation_player.play("Success")

func is_idle():
	return animation_player.current_animation == "Idle"

func cancel_activation():
	if can_activate:
		animation_player.play("Idle")
		is_activated = false
		is_success_activation = false

func disable_for(time):
	progress_bar.visible = true
	progress_bar.start_timer(time)
	is_success_activation = false
	disabled = true
	if hovered:
		Input.set_custom_mouse_cursor(DEFAULT_CURSOR)

func on_progress_complete():
	disabled = false
	progress_bar.visible = false
	if hovered:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)

func start_activation_animation(speed_activation = false):
	can_activate = true
	is_success_activation = false
	is_activated = false
	if speed_activation:
		reflex_time_msec = 250
	else:
		reflex_time_msec = 400
	animation_player.play("Activate")

func is_activated():
	return is_activated

func on_activated_start():
	is_activated = true
	activation_start_time = OS.get_ticks_msec()

func on_after_activation_feedback():
	animation_player.play("Idle")
	
