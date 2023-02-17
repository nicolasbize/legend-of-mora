extends Node

var nb_days = 1
var max_lvl_beat = 0 # beat plains => 1, beat forest => 2, etc
var prev_level_xp = 0
var next_level_xp = 10
var lvl_progression_multiplier = 1.2

var weapons := [{
	"damage": "1d4",
	"price": 20
}, {
	"damage": "1d4+1",
	"price": 30
}]

var armors := [{
	"armor": 2,
	"price": 20
}, {
	"armor": 3,
	"price": 30
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

