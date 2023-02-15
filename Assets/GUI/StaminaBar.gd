extends Node2D

var elapsed_time = 0
var total_time = 0

signal complete

onready var tick = $Tick
onready var timer = $Timer

func _ready():
	timer.connect("timeout", self, "on_timer_timeout")
	visible = false

func _process(delta):
	if visible:
		tick.scale.x = round(16 * (total_time - timer.time_left) / total_time)

func appear(time):
	total_time = time
	visible = true
	timer.start(time)

func cancel():
	visible = false
	timer.stop()

func on_timer_timeout():
	emit_signal("complete")
	visible = false
