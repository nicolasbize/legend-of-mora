extends Node2D

onready var hurt_animation_player := $HurtAnimationPlayer
onready var collider_area := $ColliderArea
onready var healthbar := $HealthBar
onready var attack_timer := $AttackTimer
onready var animation_player := $AnimationPlayer
onready var sparks := $Sparks
onready var sprite := $Sprite
onready var dodge_timer := $DodgeTimer
onready var dodge_animation_player := $DodgeAnimationPlayer
onready var reflection_timer := $ReflectionTimer

signal hit
signal die
signal prepare_hit

const Explosion = preload("res://Assets/FX/Explosion.tscn")
const DamageIndicator = preload("res://Assets/FX/DamageIndicator.tscn")

var delay_attack := 1
var max_health := 5
export(int) var health := 5
export(String) var weapon := "1d2+1"
export(float) var speed := 2.0
export(int) var gold := 0
export(int) var xp := 0
export(bool) var is_level_boss := false
export(Color) var color_advanced;
export(Color) var color_elite;
export(int) var advanced_multiplier := 2
export(int) var elite_multiplier := 3
export(GameState.Skill) var skill := GameState.Skill.Normal
export(float) var time_invincible := 3

var player = null
var state = State.IDLE
var type = null


# slime - attacks predictable after fixed time
# blob - attacks twice in a row
# giant - one-shot deals 90% HP
# gnome - steals HP when hitting
# rat - hides defense indicator
# vermin - attacks right after getting attacked or every T secs
# warrior - dodges consecutive attacks
# inferno - only gets damage by reflection, random attacks, recups HP over time
var has_power_double_attacks := false
var has_power_attack := false
var has_power_steal_hp := false
var has_power_reduce_reaction_time := false
var has_power_counter := false
var has_power_dodge := false
var has_power_reflection := false
var has_attacked_twice := false

var in_dodge_mode = false
var in_reflection = false

enum State {IDLE, ATTACK}

func _ready():
	randomize()
	connect("hit", self, "get_hurt")
	hurt_animation_player.play("RESET")
	attack_timer.connect("timeout", self, "on_attack_timer_timeout")
	dodge_timer.connect("timeout", self, "on_dodge_timer_timeout")
	reflection_timer.connect("timeout", self, "on_reflection_timer_timeout")
	max_health = health

func set_base_stats(enemy_type):
	if [GameState.E.Slime, GameState.E.Slime2, GameState.E.Slime3].has(enemy_type):
		type = GameState.E.Slime
	elif [GameState.E.Blob, GameState.E.Blob2, GameState.E.Blob3].has(enemy_type):
		type = GameState.E.Blob
		has_power_double_attacks = true
	elif [GameState.E.Giant, GameState.E.Giant2, GameState.E.Giant3].has(enemy_type):
		type = GameState.E.Giant
		has_power_attack = true
	elif [GameState.E.Gnome, GameState.E.Gnome2, GameState.E.Gnome3].has(enemy_type):
		type = GameState.E.Gnome
		has_power_steal_hp = true
	elif [GameState.E.Rat, GameState.E.Rat2, GameState.E.Rat3].has(enemy_type):
		type = GameState.E.Rat
		has_power_reduce_reaction_time = true
	elif [GameState.E.Vermin, GameState.E.Vermin2, GameState.E.Vermin3].has(enemy_type):
		type = GameState.E.Vermin
		has_power_counter = true
	elif [GameState.E.Warrior, GameState.E.Warrior2, GameState.E.Warrior3].has(enemy_type):
		type = GameState.E.Warrior
		has_power_dodge = true
	elif enemy_type == GameState.E.Inferno:
		type = GameState.E.Inferno
		has_power_reflection = true
		has_power_steal_hp = true
		in_reflection = true
		sprite.material.set_shader_param("outline_color", color_advanced);
	else:
		print("trying to access unknown stats")
	var stats = GameState.enemies[type]
	max_health = stats.health
	health = max_health
	weapon = stats.damage
	gold = stats.gold
	xp = stats.xp
	speed = stats.speed

func promote(skill_lvl):
	skill = skill_lvl
	var multiplier := 1
	match skill:
		GameState.Skill.Advanced:
			sprite.material.set_shader_param("is_special", true);
			sprite.material.set_shader_param("outline_color", color_advanced);
			sprite.offset.y -= 1
			multiplier = advanced_multiplier
		GameState.Skill.Elite:
			sprite.material.set("shader_param/is_special", true);
			sprite.material.set("shader_param/outline_color", color_elite);
			sprite.offset.y -= 1
			multiplier = elite_multiplier
	gold = round(gold * multiplier * 0.6)
	xp = round(xp * multiplier * 1.4)
	max_health = round(max_health *  multiplier)
	health = max_health
	speed = speed - 0.1 * (multiplier - 1) + rand_range(0, 0.5)
	weapon = DiceHelper.multiply(weapon, multiplier)
	
func _process(delta):
	if player != null:
		match state:
			State.IDLE:
				animation_player.play("Idle")
			State.ATTACK:
				if animation_player.current_animation != "Attack":
					animation_player.play("Attack")
					animation_player.seek(0)

	if has_power_reflection:
		sprite.material.set_shader_param("outline_color", color_advanced);
		sprite.material.set_shader_param("is_special", in_reflection);

func on_dodge_timer_timeout():
	in_dodge_mode = false

func on_reflection_timer_timeout():
	in_reflection = true

func stop_attack_animation():
	var time_until_next_attack = speed + rand_range(-0.3, 0.3)
	if has_power_double_attacks:
		if has_attacked_twice:
			has_attacked_twice = false
		else:
			time_until_next_attack = 0.3
			has_attacked_twice = true
	attack_timer.start(time_until_next_attack)
	state = State.IDLE

func start_fight(enemy):
	player = enemy
	attack_timer.start(delay_attack + rand_range(-0.3, 0.3))

func set_vulnerable():
	in_reflection = false
	reflection_timer.start(time_invincible + rand_range(-1, 1))

func stop():
	player = null
	attack_timer.stop()
	animation_player.play("Idle")

func deal_damage():
	var dmg_dealt = player.get_hurt(weapon, has_power_attack)
	if has_power_steal_hp and dmg_dealt > 0:
		var hp_gain = dmg_dealt
		if health + dmg_dealt > max_health:
			hp_gain = max_health - health
		if hp_gain > 0:
			create_dmg_indicator(dmg_dealt, true)
			health += hp_gain
			healthbar.goto_value(health, max_health, 200)

func dodge():
	dodge_animation_player.play("Dodge")

func get_hurt(dmg, is_from_reflect = false):
	hurt_animation_player.play("Hurt")
	create_dmg_indicator(dmg)
	health -= dmg
	if health < 0:
		health = 0
	if has_power_dodge and not in_dodge_mode and not is_from_reflect:
		dodge_timer.start(2)
		in_dodge_mode = true
	healthbar.goto_value(health, max_health, 200)
	sparks.amount = dmg * 2
	sparks.restart()
	sparks.emitting = true
	if health == 0:
		var explosion = Explosion.instance()
		get_owner().add_child(explosion)
		explosion.position = position
		call_deferred("queue_free")
		emit_signal("die", gold, xp, is_level_boss)
	elif has_power_counter and attack_timer.time_left > 0.4:
		attack_timer.start(0.4)

func create_dmg_indicator(dmg, is_green = false):
	var dmg_indicator = DamageIndicator.instance()
	get_owner().add_child(dmg_indicator)
	dmg_indicator.set_text(str(dmg))
	dmg_indicator.position = position + Vector2.UP * 10
	if is_green:
		dmg_indicator.set_green()

func on_attack_timer_timeout():
	prepare_attack()

func prepare_attack():
	if player != null:
		player.prepare_defense(has_power_reduce_reaction_time)
		state = State.ATTACK
