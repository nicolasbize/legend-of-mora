extends TextureRect

onready var dismiss_button := $DismissButton

func _ready():
	dismiss_button.connect("pressed", self, "on_dismiss")
	
func on_dismiss():
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
