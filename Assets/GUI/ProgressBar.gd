extends Node2D

var max_value := 0
var value := 0

onready var background = $Background
onready var max_amount_bar = $Inner
onready var current_amount_bar = $Filler

signal complete

var max_width := 0.0

var progressive_duration = 0
var start_width = null
var target_width = null
var start_time = OS.get_ticks_msec()

enum {DEFAULT, TIMER, PROGRESSIVE}
var type = DEFAULT

func _ready():
	max_width = max_amount_bar.rect_size.x

func set_width(width):
	background.rect_size.x = width + 2
	max_amount_bar.rect_size.x = width
	current_amount_bar.rect_size.x = width
	max_width = max_amount_bar.rect_size.x

func _process(delta):
	if type == PROGRESSIVE:
		var elapsed:float = OS.get_ticks_msec() - start_time as float
		if elapsed <= progressive_duration and elapsed > 0:
			current_amount_bar.rect_size.x = lerp(start_width, target_width, elapsed / progressive_duration)
		elif elapsed >= progressive_duration:
			current_amount_bar.rect_size.x = target_width
			type = DEFAULT
			emit_signal("complete")

func set_value(value, max_value):
	type = DEFAULT
	var new_width = lerp(0, max_width, value as float / max_value)
	current_amount_bar.rect_size.x = new_width

func goto_value(value, max_value, speed):
	type = PROGRESSIVE
	start_width = current_amount_bar.rect_size.x
	target_width = lerp(0, max_width, value as float / max_value)
	start_time = OS.get_ticks_msec()
	progressive_duration = speed
	
func start_timer(duration):
	current_amount_bar.rect_size.x = 0
	goto_value(100, 100, duration)
