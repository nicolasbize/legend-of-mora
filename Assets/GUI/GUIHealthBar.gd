extends Control

export(NodePath) var player_path = null

onready var middle = $Middle
onready var end = $End
onready var health = $Health

var player = null
var duration = 300
var start_time = OS.get_ticks_msec()
var start_health
var target_health

func _ready():
	player = get_node(player_path)
	player.connect("health_change", self, "refresh")
	middle.rect_scale.x = player.max_health - 2
	end.rect_position.x = player.max_health
	health.rect_scale.x = player.health
	target_health = player.health

func _process(delta):
	if target_health != health.rect_scale.x:
		var elapsed:float = OS.get_ticks_msec() - start_time as float
		if elapsed <= duration and elapsed > 0:
			health.rect_scale.x = lerp(start_health, target_health, elapsed / duration)

func refresh():
	start_time = OS.get_ticks_msec()
	start_health = health.rect_scale.x
	target_health = player.health
