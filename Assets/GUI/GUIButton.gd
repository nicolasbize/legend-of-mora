extends Node2D

signal click

const DEFAULT_CURSOR = preload("res://Assets/GUI/cursor-default.png")
const POINTER_CURSOR = preload("res://Assets/GUI/cursor-pointer.png")
const WAIT_CURSOR = preload("res://Assets/GUI/cursor-wait.png")

onready var clickable_area = $ClickableArea

func _ready():
	clickable_area.connect("mouse_entered", self, "on_mouse_entered")
	clickable_area.connect("mouse_exited", self, "on_mouse_exited")
	clickable_area.connect("input_event", self, "on_mouse_event")	
	print("ready")
	
func on_mouse_entered():
	Input.set_custom_mouse_cursor(POINTER_CURSOR)
	print("enter")

func on_mouse_exited():
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	print("exit")
	
func on_mouse_event(viewport: Object, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			print("click")
			emit_signal("click")
