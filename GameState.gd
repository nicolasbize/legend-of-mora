extends Node

var nb_days = 1
var max_lvl_beat = 0 # beat plains => 1, beat forest => 2, etc
var prev_level_xp = 0
var next_level_xp = 30
var lvl_progression_multiplier = 1.5
var min_hero_speed = 0.5 # can't attack faster than this
var max_levels = 15

var no_weapon := {
	"damage": "1d2",
	"price": 0,
	"texture": null,
	"name": "hands"
}

var weapons := [{
	"damage": "1d3",
	"price": 20,
	"texture": preload("res://Scenes/Hero/wpn-01-knife.png"),
	"name": "knife"
}, {
	"damage": "1d4",
	"price": 50,
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
	"name": "knife*"
}, {
	"damage": "3d8",
	"texture": preload("res://Scenes/Hero/wpn-04-sword.png"),
	"price": 2000,
	"name": "sword*"
}, {
	"damage": "4d6",
	"texture": preload("res://Scenes/Hero/wpn-06-falshion.png"),
	"price": 3000,
	"name": "falshion*"
}, {
	"damage": "4d8",
	"texture": preload("res://Scenes/Hero/wpn-08-axe.png"),
	"price": 4500,
	"name": "axe*"
}, {
	"damage": "6d6",
	"texture": preload("res://Scenes/Hero/wpn-09-flail.png"),
	"price": 7000,
	"name": "flail*"
}, {
	"damage": "8d6",
	"texture": preload("res://Scenes/Hero/wpn-11-pole.png"),
	"price": 11000,
	"name": "pole*"
}, {
	"damage": "8d8",
	"price": 15000,
	"texture": preload("res://Scenes/Hero/wpn-13-longsword.png"),
	"name": "longsword*"
}]

var no_armor := {
	"effect": 0,
	"price": 0,
	"texture": null,
	"name": "hands"
}

var armors := [{
	"effect": 1,
	"price": 50,
	"texture": preload("res://Scenes/Hero/armor-01.png"),
	"name": "buckler"
}, {
	"effect": 2,
	"price": 150,
	"texture": preload("res://Scenes/Hero/armor-02.png"),
	"name": "buckler*"
}, {
	"effect": 3,
	"price": 350,
	"texture": preload("res://Scenes/Hero/armor-03.png"),
	"name": "leather"
}, {
	"effect": 4,
	"price": 800,
	"texture": preload("res://Scenes/Hero/armor-04.png"),
	"name": "tower"
}, {
	"effect": 5,
	"price": 1200,
	"texture": preload("res://Scenes/Hero/armor-05.png"),
	"name": "tower*"
}, {
	"effect": 6,
	"price": 2500,
	"texture": preload("res://Scenes/Hero/armor-06.png"),
	"name": "chain mail"
}, {
	"effect": 7,
	"price": 5000,
	"texture": preload("res://Scenes/Hero/armor-07.png"),
	"name": "gold mail"
}, {
	"effect": 8,
	"price": 10000,
	"texture": preload("res://Scenes/Hero/armor-08.png"),
	"name": "plate"
}, {
	"effect": 9,
	"price": 15000,
	"texture": preload("res://Scenes/Hero/armor-09.png"),
	"name": "gold plate"
}]



var skills := [{
	"title": "multicombo",
	"price": 10,
	"xp": 1
}, {
	"title": "deflect",
	"price": 2000,
	"xp": 10
}, {
	"title": "berserk",
	"price": 2000,
	"xp": 15
}]

