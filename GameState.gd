extends Node

var nb_days = 1
var max_lvl_beat = -1 # beat plains => 1, beat forest => 2, etc
var prev_level_xp = 0
var next_level_xp = 20
var lvl_progression_multiplier = 1.4
var min_hero_speed = 0.5 # can't attack faster than this
var max_levels = 15
var berserk_quota = 0.25 # below 25% max_health, go berserk if you have the skill
var berserk_dmg_multiplier = 1.5
var combo_dmg_multiplier = 1.5

var no_weapon := {
	"damage": "1d2",
	"price": 0,
	"texture": null,
	"name": "hands"
}

var weapons := [{
	"damage": "1d3",
	"price": 10,
	"texture": preload("res://Scenes/Hero/wpn-01-knife.png"),
	"name": "knife"
}, {
	"damage": "1d4",
	"price": 30,
	"texture": preload("res://Scenes/Hero/wpn-03-sword.png"),
	"name": "sword"
}, {
	"damage": "1d6",
	"price": 90,
	"texture": preload("res://Scenes/Hero/wpn-05-falshion.png"),
	"name": "falshion"
}, {
	"damage": "1d8",
	"price": 150,
	"texture": preload("res://Scenes/Hero/wpn-07-axe.png"),
	"name": "axe"
}, {
	"damage": "1d10",
	"price": 250,
	"texture": preload("res://Scenes/Hero/wpn-08-flail.png"),
	"name": "flail"
}, {
	"damage": "2d6",
	"price": 400,
	"texture": preload("res://Scenes/Hero/wpn-10-pole.png"),
	"name": "poleaxe"
}, {
	"damage": "2d8",
	"texture": preload("res://Scenes/Hero/wpn-12-longsword.png"),
	"price": 700,
	"name": "longsword"
}, {
	"damage": "3d6",
	"texture": preload("res://Scenes/Hero/wpn-02-knife.png"),
	"price": 1250,
	"name": "knife+"
}, {
	"damage": "3d8",
	"texture": preload("res://Scenes/Hero/wpn-04-sword.png"),
	"price": 1400,
	"name": "sword+"
}, {
	"damage": "4d6",
	"texture": preload("res://Scenes/Hero/wpn-06-falshion.png"),
	"price": 1700,
	"name": "falshion+"
}, {
	"damage": "4d8",
	"texture": preload("res://Scenes/Hero/wpn-08-axe.png"),
	"price": 2000,
	"name": "axe+"
}, {
	"damage": "6d6",
	"texture": preload("res://Scenes/Hero/wpn-09-flail.png"),
	"price": 2500,
	"name": "flail+"
}, {
	"damage": "8d6",
	"texture": preload("res://Scenes/Hero/wpn-11-pole.png"),
	"price": 3000,
	"name": "pole+"
}, {
	"damage": "8d8",
	"price": 3500,
	"texture": preload("res://Scenes/Hero/wpn-13-longsword.png"),
	"name": "longsword+"
}]

var no_armor := {
	"effect": 0,
	"price": 0,
	"texture": null,
	"name": "hands"
}

var armors := [{
	"effect": 1,
	"price": 20,
	"texture": preload("res://Scenes/Hero/armor-01.png"),
	"name": "buckler"
}, {
	"effect": 2,
	"price": 100,
	"texture": preload("res://Scenes/Hero/armor-02.png"),
	"name": "targe"
}, {
	"effect": 4,
	"price": 350,
	"texture": preload("res://Scenes/Hero/armor-03.png"),
	"name": "leather"
}, {
	"effect": 7,
	"price": 800,
	"texture": preload("res://Scenes/Hero/armor-04.png"),
	"name": "tower"
}, {
	"effect": 11,
	"price": 1200,
	"texture": preload("res://Scenes/Hero/armor-05.png"),
	"name": "aegis"
}, {
	"effect": 16,
	"price": 1600,
	"texture": preload("res://Scenes/Hero/armor-06.png"),
	"name": "chain mail"
}, {
	"effect": 22,
	"price": 2000,
	"texture": preload("res://Scenes/Hero/armor-07.png"),
	"name": "gold mail"
}, {
	"effect": 29,
	"price": 2500,
	"texture": preload("res://Scenes/Hero/armor-08.png"),
	"name": "plate"
}, {
	"effect": 40,
	"price": 3500,
	"texture": preload("res://Scenes/Hero/armor-09.png"),
	"name": "gold plate"
}]

var skills := [{
	"title": "multicombo",
	"price": 100,
	"xp": 1
}, {
	"title": "deflect",
	"price": 500,
	"xp": 5
}, {
	"title": "berserk",
	"price": 1000,
	"xp": 10
}]

enum E {None, Slime, Slime2, Slime3, Blob, Blob2, Blob3, Giant, Giant2, Giant3, Gnome, Gnome2, Gnome3, Rat, Rat2, Rat3, Vermin, Vermin2, Vermin3, Warrior, Warrior2, Warrior3, Inferno, Treasure, Event}

#var levels = [[[E.Slime, E.Slime]]]

var levels = [[
	[E.Slime, E.Slime, E.Slime2],
	[E.Slime2, E.Blob, E.Slime3],
	[E.Slime2, E.Blob, E.Blob2],
	[E.Vermin, E.Slime3, E.Slime3],
	[E.Blob2, E.Vermin, E.Blob3],
], [
	[E.Vermin, E.Blob3, E.Vermin2],
	[E.Blob3, E.Vermin2, E.Blob3],
	[E.Vermin, E.Vermin2, E.Rat],
	[E.Rat, E.Vermin3, E.Vermin3],
	[E.Rat, E.Rat2, E.Gnome]
], [
	[E.Gnome, E.Rat3, E.Gnome2],
	[E.Giant, E.Gnome3, E.Giant],
	[E.Gnome3, E.Giant2, E.Warrior],
	[E.Warrior, E.Gnome3, E.Giant3],
	[E.Warrior2, E.Warrior2, E.Warrior3]
], [
	[E.Slime3, E.Slime3, E.Slime3],
	[E.Blob3, E.Blob3, E.Blob3],
	[E.Vermin3, E.Vermin3, E.Vermin3],
	[E.Rat3, E.Rat3, E.Rat3],
	[E.Gnome3, E.Gnome3, E.Gnome3],
	[E.Giant3, E.Giant3, E.Giant3],
	[E.Warrior3, E.Warrior3, E.Warrior3],
	[], [],
	[E.Inferno]
]]
