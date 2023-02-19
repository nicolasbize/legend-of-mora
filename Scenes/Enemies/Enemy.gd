extends Node2D

onready var hurt_animation_player := $HurtAnimationPlayer
onready var collider_area := $ColliderArea
onready var healthbar := $HealthBar
onready var attack_timer := $AttackTimer
onready var animation_player := $AnimationPlayer

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
var player = null
var state = State.IDLE

enum State {IDLE, ATTACK}

func _ready():
	connect("hit", self, "get_hurt")
	hurt_animation_player.play("RESET")
	attack_timer.connect("timeout", self, "on_attack_timer_timeout")
	max_health = health

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
