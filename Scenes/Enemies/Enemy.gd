extends Node2D

onready var hurt_animation_player := $HurtAnimationPlayer
onready var collider_area := $ColliderArea
onready var healthbar := $HealthBar
onready var attack_timer := $AttackTimer
onready var animation_player := $AnimationPlayer
onready var sparks := $Sparks
onready var sprite := $Sprite

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
export(int) var elite_multiplier := 4
export(GameState.Skill) var skill := GameState.Skill.Normal

var player = null
var state = State.IDLE

enum State {IDLE, ATTACK}

func _ready():
	connect("hit", self, "get_hurt")
	hurt_animation_player.play("RESET")
	attack_timer.connect("timeout", self, "on_attack_timer_timeout")
	max_health = health

func set_base_stats(enemy_type):
	var stats = null
	if [GameState.E.Slime, GameState.E.Slime2, GameState.E.Slime3].has(enemy_type):
		stats = GameState.enemies[GameState.E.Slime]
	elif [GameState.E.Blob, GameState.E.Blob2, GameState.E.Blob3].has(enemy_type):
		stats = GameState.enemies[GameState.E.Blob]
	elif [GameState.E.Giant, GameState.E.Giant2, GameState.E.Giant3].has(enemy_type):
		stats = GameState.enemies[GameState.E.Giant]
	elif [GameState.E.Gnome, GameState.E.Gnome2, GameState.E.Gnome3].has(enemy_type):
		stats = GameState.enemies[GameState.E.Gnome]
	elif [GameState.E.Rat, GameState.E.Rat2, GameState.E.Rat3].has(enemy_type):
		stats = GameState.enemies[GameState.E.Rat]
	elif [GameState.E.Vermin, GameState.E.Vermin2, GameState.E.Vermin3].has(enemy_type):
		stats = GameState.enemies[GameState.E.Vermin]
	elif [GameState.E.Warrior, GameState.E.Warrior2, GameState.E.Warrior3].has(enemy_type):
		stats = GameState.enemies[GameState.E.Warrior]
	elif enemy_type == GameState.E.Inferno:
		stats = GameState.enemies[GameState.E.Inferno]
	else:
		print("trying to access unknown stats")
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
	gold *= multiplier
	xp *= multiplier
	max_health *= multiplier
	health = max_health
	speed = speed - 0.1 * (multiplier - 1)
	weapon = DiceHelper.multiply(weapon, multiplier)
	
	# increase stats
	

func _process(delta):
	if player != null:
		match state:
			State.IDLE:
				animation_player.play("Idle")
			State.ATTACK:
				if animation_player.current_animation != "Attack":
					animation_player.play("Attack")
					animation_player.seek(0)

func stop_attack_animation():
	attack_timer.start(speed)
	state = State.IDLE

func start_fight(enemy):
	player = enemy
	attack_timer.start(delay_attack)

func stop():
	player = null
	attack_timer.stop()
	animation_player.play("Idle")

func deal_damage():
	player.get_hurt(weapon)

func get_hurt(dmg):
	hurt_animation_player.play("Hurt")
	var dmg_indicator = DamageIndicator.instance()
	get_owner().add_child(dmg_indicator)
	dmg_indicator.set_text(str(dmg))
	dmg_indicator.position = position + Vector2.UP * 10
	health -= dmg
	if health < 0:
		health = 0
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

func on_attack_timer_timeout():
	prepare_attack()

func prepare_attack():
	if player != null:
		player.prepare_defense()
		state = State.ATTACK
