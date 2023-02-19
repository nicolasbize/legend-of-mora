extends Node2D

onready var block_label := $BlockLabel
onready var combo_label := $ComboLabel
onready var miss_label := $MissLabel
onready var animation_player := $AnimationPlayer

var combo_count := 1

func block():
	animation_player.play("Block")

func miss():
	animation_player.play("Miss")
	combo_count = 1

func reset():
	animation_player.play("Idle")
	combo_count = 1

func combo():
	combo_count += 1
	combo_label.text = "combo x" + str(combo_count)
	animation_player.play("Combo")
