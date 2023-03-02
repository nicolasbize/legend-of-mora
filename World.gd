extends Node

const Level1 = preload("res://Levels/01-Level-Plains.tscn")
const Level2 = preload("res://Levels/02-Level-Forest.tscn")
const Level3 = preload("res://Levels/03-Level-Mountains.tscn")
const Level4 = preload("res://Levels/04-Level-Inferno.tscn")
const Levels = [Level1, Level2, Level3, Level4]
const Tutorial = preload("res://Assets/GUI/Tutorial.tscn")

onready var transition_animation_player := $"Game UI/TransitionAnimationPlayer"
onready var level_picker := $"Game UI/LevelPicker"
onready var level_up := $"Game UI/LevelUp"
onready var current_level := $CurrentLevel
onready var hero := $Hero
onready var health_bar := $"Game UI/Topbar/HealthBar"
onready var gold_label = $"Game UI/Topbar/GoldLabel"
onready var xp_bar := $"Game UI/Topbar/XPBar"
onready var main_music := $MainMusic
onready var upgrade_sound := $UpgradeSound
onready var battle_indicator := $"Game UI/BattleIndicator"
onready var camera := $Camera2D
onready var game_timer := $GameTimer
onready var game_ui := $"Game UI"

var current_level_index := 0

func _ready():
	level_picker.connect("load_level", self, "on_load_level")
	hero.connect("health_change", self, "on_hero_health_change")
	hero.connect("death", self, "on_hero_death")
	hero.connect("gold_change", self, "on_hero_gold_change")
	hero.connect("xp_change", self, "on_hero_xp_change")
	hero.connect("level_complete", self, "on_hero_level_complete")
	level_up.connect("level_up", self, "on_hero_level_up")
	game_timer.connect("timeout", self, "on_first_lvl_start")
	if GameState.is_loading_savegame:
		load_game()
	else:
		gold_label.set_value(hero.gold)
		xp_bar.set_value(0, GameState.next_level_xp)
#	set_test_data()	
	start_level(current_level_index)

func set_test_data():
	hero.gold = 7586
	hero.purchase_weapon(2)
	hero.purchase_armor(4)
	hero.skills = ["multicombo", "reflect"]
	hero.xp_level = 6
	hero.max_health = 90
	hero.strength = 3
	hero.vitality = 3
	hero.agility = 2
	hero.has_potion = true
	current_level_index = 0
	GameState.max_lvl_beat = 0
	GameState.next_level_xp = 230

func on_load_level(lvl_nb):
	start_level(lvl_nb)
	transition_animation_player.play("StartLevel")
	save_game()

func on_first_lvl_start():
	var tutorial = Tutorial.instance()
	game_ui.add_child(tutorial)
	get_tree().paused = true

func start_level(lvl_nb):
	current_level_index = lvl_nb
	for child in current_level.get_children():
		child.queue_free()
	var level = Levels[lvl_nb].instance()
	current_level.add_child(level)
	hero.position = Vector2(64, 56)
	hero.health = hero.max_health
	health_bar.set_width(hero.max_health)
	hero.remote_transform.remote_path = camera.get_path()
	hero.start_run()
	main_music.play(0)
	if lvl_nb == 0 and GameState.is_first_run:
		game_timer.start(2)
		GameState.is_first_run = false

func on_hero_level_complete():
	battle_indicator.reset()
	if GameState.max_lvl_beat < current_level_index:
		GameState.max_lvl_beat = current_level_index
	if GameState.max_lvl_beat < GameState.levels.size() - 1:
		save_game()		
		transition_animation_player.play("EnterTown")
	else:
		transition_animation_player.play("EnterEnding")
		
func on_ready_for_ending():
	get_tree().change_scene("res://Ending.tscn")

func save_game():
	var save_game = File.new()
	save_game.open(GameState.SAVE_FILE_LOCATION, File.WRITE)
	var game_data = to_json(GameState.get_save_data(hero))
	save_game.store_line(game_data)
	save_game.close()

func load_game():
	var save_game = File.new()
	save_game.open(GameState.SAVE_FILE_LOCATION, File.READ)
	var game_data =  parse_json(save_game.get_line())
	GameState.load_data(game_data, hero)
	current_level_index = GameState.max_lvl_beat + 1
	save_game.close()
	xp_bar.goto_value(hero.xp, GameState.next_level_xp, 200)
	health_bar.set_width(hero.max_health)

func on_hero_health_change(health):
	health_bar.goto_value(health, hero.max_health, 200)

func on_hero_gold_change(gold):
	gold_label.set_value(gold)
	
func on_hero_xp_change(xp):
	xp_bar.goto_value(hero.xp, GameState.next_level_xp, 200)
	if xp >= GameState.next_level_xp:
		level_up.refresh(hero)
		transition_animation_player.play("StartLevelUp")
		upgrade_sound.play()
		get_tree().paused = true

func on_hero_level_up(perk):
	hero.xp_level += 1
	hero.xp -= GameState.next_level_xp
	GameState.next_level_xp = round(GameState.next_level_xp * 2.2)
	xp_bar.goto_value(hero.xp, GameState.next_level_xp, 200)
	if perk == "strength":
		hero.strength += 1
	elif perk == "agility":
		hero.agility += 1
	else:
		hero.vitality += 1
		hero.max_health += 10
		hero.health += 10
		health_bar.set_width(hero.max_health)
		hero.emit_signal("health_change", hero.health)
	transition_animation_player.play("FinishLevelUp")
	get_tree().paused = false

func on_hero_death():
	GameState.nb_days += 1
	transition_animation_player.play("EnterTown")
	save_game()
	
