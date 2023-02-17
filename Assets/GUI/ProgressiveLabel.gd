extends Label

export(int) var speed_change = 200

var start_value = null
var current_value = null
var target_value = null
var start_time = OS.get_ticks_msec()

func _process(delta):
	if current_value != null and current_value != target_value:
		var elapsed:float = OS.get_ticks_msec() - start_time as float
		if elapsed <= speed_change:
			current_value = round(lerp(start_value, target_value, elapsed / speed_change))
			text = str(current_value)
		else:
			current_value = target_value
			text = str(current_value)

func set_value(value):
	if current_value == null:
		current_value = value
		target_value = value
		text = str(value)
	else:
		start_value = current_value
		target_value = value
		start_time = OS.get_ticks_msec()
