extends Camera2D


export(float) var shake_amount := 0
export(Vector2) var default_offset := offset

onready var timer := $Timer
onready var tween := $Tween

func _ready():
	set_process(false)
	timer.connect("timeout", self, "on_timer_timeout")
	randomize()

func _process(delta):
	offset = Vector2(rand_range(-1, 1) * shake_amount, rand_range(-1, 1) * shake_amount)
	

func shake(time, amount):
	shake_amount = amount
	set_process(true)
	timer.start(time)

func on_timer_timeout():
	set_process(false)
	tween.interpolate_property(self, "offset", offset, default_offset, 0.1, 6, 2)
	tween.start()
