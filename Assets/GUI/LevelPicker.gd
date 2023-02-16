extends Control

signal load_level

onready var button_plains = $ButtonPlains
onready var button_forest = $ButtonForest
onready var button_mountain = $ButtonMountain
onready var button_boss = $ButtonBoss

func _ready():
	button_plains.connect("pressed", self, "on_level_click", [1])
	button_forest.connect("pressed", self, "on_level_click", [2])
	button_mountain.connect("pressed", self, "on_level_click", [3])
	button_boss.connect("pressed", self, "on_level_click", [4])

func refresh():
	button_forest.disabled = GameState.max_lvl_beat < 1
	button_mountain.disabled = GameState.max_lvl_beat < 2
	button_boss.disabled = GameState.max_lvl_beat < 3

func on_level_click(lvl):
	emit_signal("load_level", lvl)
