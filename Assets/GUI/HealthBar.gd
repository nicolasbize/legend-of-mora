extends Node2D

onready var health_tick = $"Sprite/Health-tick"

const max_size = 14

func refresh(health, max_health):
	health_tick.scale.x = round(max_size * health / max_health)
