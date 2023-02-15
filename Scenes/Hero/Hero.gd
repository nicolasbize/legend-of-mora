extends KinematicBody2D

export(NodePath) var potion_button_path = null
export(NodePath) var defend_button_path = null
export(NodePath) var attack_button_path = null

export(int) var strength := 1
export(int) var dexterity := 1
export(int) var composition := 1
export(String) var weapon := "1d2+1"
export(float) var speed := 2.0
export(int) var armor := 1
export(int) var max_health := (3+composition) * 4
export(int) var health := max_health
export(int) var nb_potions := 1

export(int) var acceleration := 800
export(int) var max_speed := 150
export(int) var friction := 800
export(bool) var automove := true

enum state {IDLE, MOVING, ACTIVE, ATTACK, DYING, DEAD}

var velocity := Vector2.ZERO
var current_state = state.IDLE
var current_enemy = null
var potion_button = null
var defend_button = null
var attack_button = null

onready var animation_player := $AnimationPlayer
onready var hurt_animation_player := $HurtAnimationPlayer
onready var hero_sprite := $HeroSprite
onready var start_timer := $StartTimer
onready var hit_area := $HitArea

const DamageIndicator = preload("res://Assets/FX/DamageIndicator.tscn")

signal health_change

func _ready():
	start_timer.connect("timeout", self, "start_run")
	hit_area.connect("area_entered", self, "enter_fight")
	potion_button = get_node(potion_button_path)
	defend_button = get_node(defend_button_path)
	attack_button = get_node(attack_button_path)
	potion_button.disabled = true
	defend_button.disabled = true
	attack_button.disabled = true
	attack_button.connect("pressed", self, "on_attack_press")

func _physics_process(delta):
	if not GameState.in_town:
		match current_state:
			state.IDLE:
				animation_player.play("Idle")
				velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			state.MOVING:
				animation_player.play("Run")
				velocity = velocity.move_toward(Vector2.RIGHT * max_speed, acceleration * delta)
			state.ATTACK:
				animation_player.play("Attack")
			state.DYING:
				animation_player.play("Die")
		velocity = move_and_slide(velocity)

func is_in_battle():
	return current_enemy != null

func start_run():
	current_state = state.MOVING

func enter_fight(enemy_area):
	current_enemy = enemy_area.get_owner()
	current_enemy.connect("die", self, "enemy_death")
	current_enemy.start_fight(self)
	current_state = state.IDLE
	if nb_potions > 0:
		potion_button.disabled = false
	defend_button.disabled = false
	attack_button.disabled = false
	
func on_attack_press():
	current_state = state.ATTACK
	attack_button.disable_for(speed)

func perform_attack():
	if current_enemy != null:
		var dmg = DiceHelper.roll("1d3")
		current_enemy.emit_signal("hit", dmg)

func finish_attack_animation():
	current_state = state.IDLE

func finish_dying_animation():
	current_state = state.DEAD

func get_hurt(dmg):
	hurt_animation_player.play("Hurt")
	var damage = DiceHelper.roll(dmg)
	var dmg_indicator = DamageIndicator.instance()
	get_owner().add_child(dmg_indicator)
	dmg_indicator.set_text(str(damage))
	dmg_indicator.position = position + Vector2.UP * 10
	health -= damage
	if health <= 0:
		process_death()
	emit_signal("health_change")

func process_death():
	health = 0
	current_state = state.DYING
	current_enemy.stop()
	potion_button.disabled = true
	attack_button.disabled = true
	defend_button.disabled = true

func enemy_death():
	current_enemy = null
	start_timer.start(0.3)

func reset_attack():
	attack_button.frame = 0
	current_state = state.IDLE
