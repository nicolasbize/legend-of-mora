extends "res://Assets/GUI/InfoPanel.gd"

onready var strength_label = $Background/Container/StrengthLabel
onready var agility_label = $Background/Container/AgilityLabel
onready var vitality_label = $Background/Container/VitalityLabel
onready var attack_label = $Background/Container/AttackLabel
onready var dmg_label = $Background/Container/DmgLabel

func on_return_button():
	transition_animation.play("LeaveStats")

func refresh():
	vitality_label.text = str(player.vitality) + " (" + str(player.max_health) + " hp)"
	strength_label.text = str(player.strength) + " (+" + str(player.strength) + " dmg)"
	var att_sec =  round((1.0 / (player.get_attack_speed() / 1000.0)) * 10) / 10.0
	agility_label.text = str(player.agility) + " (" + str(att_sec) + " atk/s)"
	var dmg = player.weapon.damage + "+" + str(player.strength)
	attack_label.text = dmg + " (" + DiceHelper.get_range(dmg) + ")"
	var avg_att = DiceHelper.get_avg(dmg)
	var dps = round(att_sec * avg_att * 100) / 100.0
	dmg_label.text = str(dps) + " dps"
