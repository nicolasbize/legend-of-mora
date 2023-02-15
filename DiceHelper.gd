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
