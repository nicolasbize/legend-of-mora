extends Node

# 1d3+4
func roll(str_value):
	randomize()
	var parts = str_value.split("+")
	var total = 0
	if parts.size() == 2:
		total += int(parts[1])
	var mods = parts[0].split("d")
	for i in int(mods[0]):
		total += randi() % int(mods[1]) + 1
	return total

func get_range(str_value):
	var parts = str_value.split("+")
	var min_value = 0
	var max_value = 0
	if parts.size() == 2:
		min_value += int(parts[1])
		max_value += int(parts[1])
	var mods = parts[0].split("d")
	for i in int(mods[0]):
		min_value += 1
		max_value += int(mods[1])
	return str(min_value) + "-" + str(max_value)
	
