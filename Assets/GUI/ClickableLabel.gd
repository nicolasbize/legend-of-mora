extends Label

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
const POINTER_CURSOR = preload("res://Assets/GUI/cursor-pointer.png")

signal pressed

export(bool) var disabled := false
export(Color) var disabled_color := Color.gray
export(Color) var hover_color := Color.yellow
export(bool) var is_toggle := false
var original_color

onready var click_sound := $ClickSound

func _ready():
	connect("mouse_entered", self, "on_mouse_enter")
	connect("mouse_exited", self, "on_mouse_exit")
	connect("gui_input", self, "on_mouse_input")
	original_color = get("custom_colors/font_color")
	if disabled:
		disable()

func disable():
	set("custom_colors/font_color", disabled_color)
	
func on_mouse_enter():
	if not disabled:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)
		set("custom_colors/font_color", hover_color)
	
func on_mouse_exit():
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	if not disabled:
		set("custom_colors/font_color", original_color)

func on_mouse_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		emit_signal("pressed")
		click_sound.play()
		if not is_toggle:
			on_mouse_exit()
	
