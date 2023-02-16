extends Node2D

var max_value := 0
var value := 0

onready var background = $Background
onready var max_amount_bar = $Inner
onready var current_amount_bar = $Filler
onready var timer = $Timer

signal complete

var max_width := 0.0

# timer type
var timer_duration = null

var progressive_duration = 0
var start_width = null
var target_width = null
var start_time = OS.get_ticks_msec()

enum {DEFAULT, TIMER, PROGRESSIVE}
var type = DEFAULT

func _ready():
	timer.connect("timeout", self, "on_timer_timeout")
	max_width = max_amount_bar.rect_size.x

func set_width(width):
	background.rect_size.x = width + 2
	max_amount_bar.rect_size.x = width
	current_amount_bar.rect_size.x = width
	max_width = max_amount_bar.rect_size.x

func _process(delta):
	if type == TIMER:
		var new_width = lerp(0, max_width, (timer_duration - timer.time_left) as float / timer_duration)
		current_amount_bar.rect_size.x = new_width
	elif type == PROGRESSIVE:
		var elapsed:float = OS.get_ticks_msec() - start_time as float
		if elapsed <= progressive_duration and elapsed > 0:
			current_amount_bar.rect_size.x = lerp(start_width, target_width, elapsed / progressive_duration)

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
	type = TIMER
	timer_duration = duration
	timer.start(duration)

func on_timer_timeout():
	type = DEFAULT
	timer.stop()
	emit_signal("complete")
