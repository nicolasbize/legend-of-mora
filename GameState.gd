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
	"texture": null
}

var weapons := [{
	"damage": "1d3",
	"price": 20,
	"texture": preload("res://Scenes/Hero/wpn-01-knife.png")
}, {
	"damage": "1d4",
	"price": 50,
	"texture": preload("res://Scenes/Hero/wpn-02-knife.png")
}, {
	"damage": "1d6",
	"price": 90,
	"texture": preload("res://Scenes/Hero/wpn-03-sword.png")
}, {
	"damage": "1d8",
	"price": 150,
	"texture": preload("res://Scenes/Hero/wpn-04-sword.png")
}, {
	"damage": "1d10",
	"price": 250,
	"texture": preload("res://Scenes/Hero/wpn-05-falshion.png")
}, {
	"damage": "2d6",
	"price": 400,
	"texture": preload("res://Scenes/Hero/wpn-06-falshion.png")
}, {
	"damage": "2d8",
	"price": 700,
	"texture": preload("res://Scenes/Hero/wpn-07-axe.png")
}, {
	"damage": "3d6",
	"price": 1250,
	"texture": preload("res://Scenes/Hero/wpn-08-axe.png")
}, {
	"damage": "3d8",
	"price": 2000,
	"texture": preload("res://Scenes/Hero/wpn-08-flail.png")
}, {
	"damage": "4d6",
	"price": 3000,
	"texture": preload("res://Scenes/Hero/wpn-09-flail.png")
}, {
	"damage": "4d8",
	"price": 4500,
	"texture": preload("res://Scenes/Hero/wpn-10-pole.png")
}, {
	"damage": "6d6",
	"price": 7000,
	"texture": preload("res://Scenes/Hero/wpn-11-pole.png")
}, {
	"damage": "8d6",
	"price": 11000,
	"texture": preload("res://Scenes/Hero/wpn-12-longsword.png")
}, {
	"damage": "8d8",
	"price": 15000,
	"texture": preload("res://Scenes/Hero/wpn-13-longsword.png")
}]

var no_armor := {
	"armor": 0,
	"price": 0,
	"texture": null
}

var armors := [{
	"armor": 1,
	"price": 50,
	"texture": preload("res://Scenes/Hero/armor-01.png")
}, {
	"armor": 2,
	"price": 150,
	"texture": preload("res://Scenes/Hero/armor-02.png")
}, {
	"armor": 3,
	"price": 350,
	"texture": preload("res://Scenes/Hero/armor-03.png")
}, {
	"armor": 4,
	"price": 800,
	"texture": preload("res://Scenes/Hero/armor-04.png")
}, {
	"armor": 5,
	"price": 1200,
	"texture": preload("res://Scenes/Hero/armor-05.png")
}, {
	"armor": 6,
	"price": 2500,
	"texture": preload("res://Scenes/Hero/armor-06.png")
}, {
	"armor": 7,
	"price": 5000,
	"texture": preload("res://Scenes/Hero/armor-07.png")
}, {
	"armor": 8,
	"price": 10000,
	"texture": preload("res://Scenes/Hero/armor-08.png")
}, {
	"armor": 9,
	"price": 15000,
	"texture": preload("res://Scenes/Hero/armor-09.png")
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

