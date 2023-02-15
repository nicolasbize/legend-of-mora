extends TextureButton

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
const POINTER_CURSOR = preload("res://Assets/GUI/cursor-pointer.png")

export(String) var display_name
export(NodePath) var label_path

var label = null

func _ready():
	if label_path != null:
		label = get_node(label_path)
	connect("mouse_entered", self, "on_mouse_enter")
	connect("mouse_exited", self, "on_mouse_exit")
	connect("pressed", self, "on_mouse_exit")
	
func on_mouse_enter():
	if not disabled:
		Input.set_custom_mouse_cursor(POINTER_CURSOR)
		if label_path != null:
			label.text = display_name
	
func on_mouse_exit():
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	if label_path != null:
		label.text = ""
