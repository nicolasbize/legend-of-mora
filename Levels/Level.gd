extends Node2D

enum EnemyType {None, Slime, SlimeAdvanced, SlimeElite, Blob, BlobAdvanced, BlobElite, Giant, GiantAdvanced, GiantElite, Gnome, GnomeAdvanced, GnomeElite, Rat, RatAdvanced, RatElite, Vermin, VerminAdvanced, VerminElite, Warrior, WarriorAdvanced, WarriorElite, Inferno, Treasure, Event}

export(int) var level_nb
var margin_between_enemies := 50
var space_left := 250

onready var enemies_node = $Enemies

const Slime = preload("res://Scenes/Enemies/Slime.tscn")
const Blob = preload("res://Scenes/Enemies/Blob.tscn")
const Vermin = preload("res://Scenes/Enemies/Vermin.tscn")
const Warrior = preload("res://Scenes/Enemies/Warrior.tscn")
const Rat = preload("res://Scenes/Enemies/Rat.tscn")
const Gnome = preload("res://Scenes/Enemies/Gnome.tscn")
const Giant = preload("res://Scenes/Enemies/Giant.tscn")
const Inferno = preload("res://Scenes/Enemies/Inferno-Boss.tscn")

# map this to enum
const EnemyMap = {
	GameState.E.Slime: Slime,
	GameState.E.Slime2: Slime,
	GameState.E.Slime3: Slime,
	GameState.E.Blob: Blob,
	GameState.E.Blob2: Blob,
	GameState.E.Blob3: Blob,
	GameState.E.Vermin: Vermin,
	GameState.E.Vermin2: Vermin,
	GameState.E.Vermin3: Vermin,
	GameState.E.Warrior: Warrior,
	GameState.E.Warrior2: Warrior,
	GameState.E.Warrior3: Warrior,
	GameState.E.Rat: Rat,
	GameState.E.Rat2: Rat,
	GameState.E.Rat3: Rat,
	GameState.E.Giant: Giant,
	GameState.E.Giant2: Giant,
	GameState.E.Giant3: Giant,
	GameState.E.Gnome: Gnome,
	GameState.E.Gnome2: Gnome,
	GameState.E.Gnome3: Gnome,
	GameState.E.Inferno: Inferno
}

func _ready():
	load_level(level_nb)

func load_level(nb):
	var current_x = space_left
	var is_last_row = false
	var is_last_enemy = false
	for row_index in range(GameState.levels[nb].size()):
		is_last_row = row_index == GameState.levels[nb].size() - 1
		var row = GameState.levels[nb][row_index]
		for enemy_index in range(row.size()):
			is_last_enemy = enemy_index == row.size() - 1
			var enemy = row[enemy_index]
			if enemy == GameState.E.Event:
				pass
			elif enemy == GameState.E.Treasure:
				pass
			else:
				var instance = EnemyMap[enemy].instance()
				enemies_node.add_child(instance)
				instance.set_owner(enemies_node)
				instance.position = Vector2(current_x, 59)
				instance.set_base_stats(enemy)
				if (GameState.is_advanced(enemy)):
					instance.promote(GameState.Skill.Advanced)
				elif GameState.is_elite(enemy):
					instance.promote(GameState.Skill.Elite)
				instance.is_level_boss = is_last_row and is_last_enemy
				current_x += margin_between_enemies
		current_x += margin_between_enemies
