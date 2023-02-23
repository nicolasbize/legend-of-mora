extends Node2D

onready var block_label := $BlockLabel
onready var combo_label := $ComboLabel
onready var miss_label := $MissLabel
onready var animation_player := $AnimationPlayer

func block():
	animation_player.play("Block")

func miss():
	animation_player.play("Miss")

func reset():
	animation_player.play("Idle")

func combo(combo_count):
	block_label.visible = false
	combo_label.text = "combo x" + str(combo_count)
	animation_player.play("Combo")
