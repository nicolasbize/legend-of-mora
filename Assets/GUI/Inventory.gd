extends "res://Assets/GUI/InfoPanel.gd"

onready var level_label = $Background/Inventory/LevelLabel
onready var gold_label = $Background/Inventory/GoldLabel
onready var armor_label = $Background/Inventory/ArmorLabel
onready var weapon_label = $Background/Inventory/WeaponLabel

func on_return_button():
	transition_animation.play("LeaveInventory")

func refresh():
	var current_lvl_xp = str(player.xp - GameState.prev_level_xp)
	var next_lvl_xp = str(GameState.next_level_xp)
	level_label.text = "lvl " + str(player.xp_level) + " (" + current_lvl_xp + "/" + next_lvl_xp + ")"
	gold_label.text = str(player.gold)
	weapon_label.text = player.weapon.name + " (" + str(player.weapon.damage) + ")"
	armor_label.text = player.armor.name + " (-" + str(player.armor.effect) + ")"
	
