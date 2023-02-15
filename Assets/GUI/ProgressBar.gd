extends Node2D

export(float) var max_value := 0
export(float) var value := 0

onready var background = $Background
onready var filler = $Filler
onready var timer = $Timer

signal complete

var timed = false
var delay = 0

func _ready():
	timer.connect("timeout", self, "on_timer_timeout")

func _process(delta):
	if timed:
		set_value(delay, delay - timer.time_left)

func set_value(max_value, current):
	var max_x = background.rect_size.x
	filler.rect_size.x = lerp(0, max_x, current / max_value)
	
func start_timer(time):
	delay = time
	timer.start(time)
	timed = true

func on_timer_timeout():
	timed = false
	timer.stop()
	emit_signal("complete")
