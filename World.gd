extends Node

const Level1 = preload("res://Levels/01-Level-Plains.tscn")
const Level2 = preload("res://Levels/02-Level-Forest.tscn")
const Level3 = preload("res://Levels/03-Level-Mountains.tscn")
const Level4 = preload("res://Levels/04-Level-Inferno.tscn")
const Levels = [Level1, Level2, Level3, Level4]
onready var transition_animation_player := $"Game UI/TransitionAnimationPlayer"
onready var level_picker := $"Game UI/LevelPicker"
onready var level_up := $"Game UI/LevelUp"
onready var current_level := $CurrentLevel
onready var hero := $Hero
onready var health_bar := $"Game UI/Topbar/HealthBar"
onready var gold_label = $"Game UI/Topbar/GoldLabel"
onready var xp_bar := $"Game UI/Topbar/XPBar"

func _ready():
	level_picker.connect("load_level", self, "on_load_level")
	hero.connect("health_change", self, "on_hero_health_change")
	hero.connect("death", self, "on_hero_death")
	hero.connect("gold_change", self, "on_hero_gold_change")
	hero.connect("xp_change", self, "on_hero_xp_change")
	level_up.connect("level_up", self, "on_hero_level_up")
	gold_label.set_value(hero.gold)
	xp_bar.set_value(0, GameState.next_level_xp)
	start_level(4)

func on_load_level(lvl_nb):
	start_level(lvl_nb)
	transition_animation_player.play("StartLevel")

func start_level(lvl_nb):
	for child in current_level.get_children():
		child.queue_free()
	var level = Levels[lvl_nb-1].instance()
	current_level.add_child(level)
	hero.position = Vector2(64, 56)
	hero.health = hero.max_health
	health_bar.set_width(hero.max_health)
	hero.start_run()

func on_hero_health_change(health):
	health_bar.goto_value(health, hero.max_health, 200)

func on_hero_gold_change(gold):
	gold_label.set_value(gold)
	
func on_hero_xp_change(xp):
	xp_bar.goto_value(hero.xp - GameState.prev_level_xp, GameState.next_level_xp, 200)
	if xp >= GameState.next_level_xp:
		level_up.refresh(hero)
		transition_animation_player.play("StartLevelUp")
		get_tree().paused = true

func on_hero_level_up(perk):
	hero.xp_level += 1
	GameState.prev_level_xp = GameState.next_level_xp
	GameState.next_level_xp = round(GameState.next_level_xp * 2.2)
	xp_bar.goto_value(hero.xp - GameState.prev_level_xp, GameState.next_level_xp, 200)
	if perk == "strength":
		hero.strength += 1
	elif perk == "agility":
		hero.agility += 1
	else:
		hero.vitality += 1
		hero.max_health += 5
		hero.health += 5
		health_bar.set_width(hero.max_health)
		hero.emit_signal("health_change", hero.health)
	transition_animation_player.play("FinishLevelUp")
	get_tree().paused = false

func on_hero_death():
	GameState.nb_days += 1
	transition_animation_player.play("EnterTown")
	
