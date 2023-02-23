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
	
func get_avg(str_value):
	var parts = str_value.split("+")
	var total := 0.0
	if parts.size() == 2:
		total += int(parts[1])
	var mods = parts[0].split("d")
	for i in int(mods[0]):
		total += (1 + int(mods[1])) / 2.0
	return total
	
func multiply(str_value, multiplier:int):
	var parts = str_value.split("+")
	var modifier := 0
	if parts.size() == 2:
		modifier = int(parts[1]) * multiplier
		return parts[0] + "+" + str(modifier)
	else:
		return str_value
