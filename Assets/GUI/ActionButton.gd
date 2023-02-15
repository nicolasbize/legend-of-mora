extends TextureButton

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
const POINTER_CURSOR = preload("res://Assets/GUI/cursor-pointer.png")
const WAIT_CURSOR = preload("res://Assets/GUI/cursor-wait.png")

onready var progress_bar = $ProgressBar
var hovered := false

func _ready():
	connect("mouse_entered", self, "on_mouse_enter")
	connect("mouse_exited", self, "on_mouse_exit")
	progress_bar.visible = false
	progress_bar.connect("complete", self, "on_progress_complete")

func on_mouse_enter():
	hovered = true
	if not disabled:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)
	
func on_mouse_exit():
	hovered = false
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)

func disable_for(time):
	progress_bar.visible = true
	progress_bar.start_timer(time)
	disabled = true
	if hovered:
		Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	
func on_progress_complete():
	disabled = false
	progress_bar.visible = false
	if hovered:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)
