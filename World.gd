extends Node

const Level1 = preload("res://Levels/01-Level-Plains.tscn")
const Levels = [Level1]
onready var transition_animation_player := $"Game UI/TransitionAnimationPlayer"
onready var level_picker := $"Game UI/LevelPicker"
onready var current_level := $CurrentLevel
onready var hero := $Hero
onready var health_bar := $"Game UI/Topbar/HealthBar"

func _ready():
	if GameState.in_town:
		transition_animation_player.play("EnterTown")
	level_picker.connect("load_level", self, "on_load_level")
	hero.connect("health_change", self, "on_hero_health_change")
	start_level(1)

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
