extends Node2D

enum EnemyType {None, Slime, SlimeAdvanced, SlimeElite, Blob, BlobAdvanced, BlobElite, Giant, GiantAdvanced, GiantElite, Gnome, GnomeAdvanced, GnomeElite, Rat, RatAdvanced, RatElite, Vermin, VerminAdvanced, VerminElite, Warrior, WarriorAdvanced, WarriorElite, Inferno, Treasure, Event}

export(int) var level_nb
var margin_between_enemies := 50
var space_left := 250

onready var enemies_node = $Enemies

const Slime = preload("res://Scenes/Enemies/Slime.tscn")
const SlimeAdvanced = preload("res://Scenes/Enemies/Slime-Advanced.tscn")
const SlimeElite = preload("res://Scenes/Enemies/Slime-Elite.tscn")
const Blob = preload("res://Scenes/Enemies/Blob.tscn")
const BlobAdvanced = preload("res://Scenes/Enemies/Blob-Advanced.tscn")
const BlobElite = preload("res://Scenes/Enemies/Blob-Elite.tscn")
const Vermin = preload("res://Scenes/Enemies/Vermin.tscn")
const VerminAdvanced = preload("res://Scenes/Enemies/Vermin-Advanced.tscn")
const VerminElite = preload("res://Scenes/Enemies/Vermin-Elite.tscn")
const Warrior = preload("res://Scenes/Enemies/Warrior.tscn")
const WarriorAdvanced = preload("res://Scenes/Enemies/Warrior-Advanced.tscn")
const WarriorElite = preload("res://Scenes/Enemies/Warrior-Elite.tscn")
const Rat = preload("res://Scenes/Enemies/Rat.tscn")
const RatAdvanced = preload("res://Scenes/Enemies/Rat-Advanced.tscn")
const RatElite = preload("res://Scenes/Enemies/Rat-Elite.tscn")
const Gnome = preload("res://Scenes/Enemies/Gnome.tscn")
const GnomeAdvanced = preload("res://Scenes/Enemies/Gnome-Advanced.tscn")
const GnomeElite = preload("res://Scenes/Enemies/Gnome-Elite.tscn")
const Giant = preload("res://Scenes/Enemies/Giant.tscn")
const GiantAdvanced = preload("res://Scenes/Enemies/Giant-Advanced.tscn")
const GiantElite = preload("res://Scenes/Enemies/Giant-Elite.tscn")
const Inferno = preload("res://Scenes/Enemies/Inferno-Boss.tscn")

# map this to enum
const EnemyMap = {
	GameState.E.Slime: Slime,
	GameState.E.Slime2: SlimeAdvanced,
	GameState.E.Slime3: SlimeElite,
	GameState.E.Blob: Blob,
	GameState.E.Blob2: BlobAdvanced,
	GameState.E.Blob3: BlobElite,
	GameState.E.Vermin: Vermin,
	GameState.E.Vermin2: VerminAdvanced,
	GameState.E.Vermin3: VerminElite,
	GameState.E.Warrior: Warrior,
	GameState.E.Warrior2: WarriorAdvanced,
	GameState.E.Warrior3: WarriorElite,
	GameState.E.Rat: Rat,
	GameState.E.Rat2: RatAdvanced,
	GameState.E.Rat3: RatElite,
	GameState.E.Giant: Giant,
	GameState.E.Giant2: GiantAdvanced,
	GameState.E.Giant3: GiantElite,
	GameState.E.Gnome: Gnome,
	GameState.E.Gnome2: GnomeAdvanced,
	GameState.E.Gnome3: GnomeElite,
	GameState.E.Inferno: Inferno
}

func _ready():
	load_level(level_nb)

func load_level(nb):
	var current_x = space_left
	for row in GameState.levels[nb]:
		for enemy in row:
			if enemy == GameState.E.Event:
				pass
			elif enemy == GameState.E.Treasure:
				pass
			else:
				var instance = EnemyMap[enemy].instance()
				enemies_node.add_child(instance)
				instance.set_owner(enemies_node)
				instance.position = Vector2(current_x, 59)
				current_x += margin_between_enemies
		current_x += margin_between_enemies * 2
