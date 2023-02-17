extends Control

onready var level_up_label = $LevelUpLabel
onready var current_hp_label = $CurrentHPLabel
onready var current_dmg_label = $CurrentDmgLabel
onready var current_speed_label = $CurrentSpeedLabel
onready var hp_inc_label = $HPIncLabel
onready var speed_inc_label = $SpeedIncLabel
onready var dmg_inc_label = $DmgIncLabel
onready var inc_hp_button = $IncHPButton
onready var inc_str_button = $IncStrButton
onready var inc_spd_button = $IncSpdButton

var player = null

signal level_up

func _ready():
	inc_str_button.connect("pressed", self, "on_perk_pick", ["strength"])
	inc_spd_button.connect("pressed", self, "on_perk_pick", ["agility"])
	inc_hp_button.connect("pressed", self, "on_perk_pick", ["vitality"])

func refresh(hero):
	player = hero
	level_up_label.text = "Level " + str(hero.xp_level + 1) + "!"
	current_hp_label.text = str(hero.max_health)
	current_speed_label.text = str(hero.agility)
	current_dmg_label.text = str(hero.strength)
	if hero.vitality < GameState.max_levels: 
		hp_inc_label.text = "+5"
		inc_hp_button.disabled = false
	else:
		hp_inc_label.text = "max"
		inc_hp_button.disabled = true
		
	if hero.agility < GameState.max_levels:
		speed_inc_label.text = "+1"
		inc_spd_button.disabled = false
	else:
		speed_inc_label.text = "max"
		inc_spd_button.disabled = true
		
	if hero.strength < GameState.max_levels:
		dmg_inc_label.text = "+1"
		inc_str_button.disabled = false
	else:
		dmg_inc_label.text = "max"
		inc_str_button.disabled = true

func on_perk_pick(perk):
	emit_signal("level_up", perk)
