extends KinematicBody2D

export(NodePath) var potion_button_path = null
export(NodePath) var defend_button_path = null
export(NodePath) var attack_button_path = null

export(int) var xp := 0
export(int) var xp_level := 1

export(int) var strength := 1 # attack strength
export(int) var agility := 1 # attack + defend speed
export(int) var vitality := 1 # hit points

export(float) var base_speed := 2100 # millis between each attack
export(int) var max_health := 16
export(int) var health := max_health
export(bool) var has_potion := true
export(int) var gold := 0

var skills := [] # combo, berserk, deflect
var weapon := GameState.no_weapon
var armor := GameState.no_armor

# movement
var velocity := Vector2.ZERO
var movement_acceleration := 400
var max_movement_speed := 50
var movement_friction := 800

enum state {IDLE, MOVING, ACTIVE, ATTACK, DYING, DEAD}
var current_state = state.IDLE

var current_enemy = null
var potion_button = null
var defend_button = null
var attack_button = null

onready var animation_player := $AnimationPlayer
onready var hurt_animation_player := $HurtAnimationPlayer
onready var hero_sprite := $HeroSprite
onready var hit_area := $HitArea
onready var weapon_sprite := $WeaponSprite
onready var armor_sprite := $ArmorSprite

const DamageIndicator = preload("res://Assets/FX/DamageIndicator.tscn")

signal health_change
signal death
signal gold_change
signal xp_change

func _ready():
	hit_area.connect("area_entered", self, "enter_fight")
	potion_button = get_node(potion_button_path)
	defend_button = get_node(defend_button_path)
	attack_button = get_node(attack_button_path)
	attack_button.connect("pressed", self, "on_attack_press")
	potion_button.connect("pressed", self, "on_potion_press")

func _physics_process(delta):
	match current_state:
		state.IDLE:
			animation_player.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, movement_friction * delta)
		state.MOVING:
			animation_player.play("Run")
			velocity = velocity.move_toward(Vector2.RIGHT * max_movement_speed, movement_acceleration * delta)
		state.ATTACK:
			animation_player.play("Attack")
		state.DYING:
			animation_player.play("Die")
	velocity = move_and_slide(velocity)

func is_in_battle():
	return current_enemy != null

func start_run():
	current_state = state.MOVING
	potion_button.disabled = not has_potion
	attack_button.disabled = false
	defend_button.disabled = false

func enter_fight(enemy_area):
	current_enemy = enemy_area.get_owner()
	current_enemy.connect("die", self, "enemy_death")
	current_enemy.start_fight(self)
	current_state = state.IDLE
	
func on_attack_press():
	current_state = state.ATTACK
	attack_button.disable_for(get_attack_speed())

func get_attack_speed():
	return base_speed - 100 * agility

func on_potion_press():
	if health < max_health:
		health = max_health
		emit_signal("health_change", health)
		has_potion = false
		potion_button.disabled = true

func perform_attack():
	if current_enemy != null:
		var dmg = DiceHelper.roll(weapon.damage + "+" + str(strength))
		current_enemy.emit_signal("hit", dmg)

func finish_attack_animation():
	current_state = state.IDLE
	if current_enemy == null:
		yield(get_tree().create_timer(0.3), "timeout")
		current_state = state.MOVING

func finish_dying_animation():
	current_state = state.DEAD
	emit_signal("death")

func get_hurt(dmg):
	hurt_animation_player.play("Hurt")
	var damage = DiceHelper.roll(dmg)
	var dmg_indicator = DamageIndicator.instance()
	get_owner().add_child(dmg_indicator)
	dmg_indicator.set_text(str(damage))
	dmg_indicator.position = position + Vector2.UP * 10
	health -= damage
	emit_signal("health_change", health)
	if health <= 0:
		process_death()
	
func get_potion_price():
	return vitality * 10
	
func process_death():
	health = 0
	current_state = state.DYING
	current_enemy.stop()
	potion_button.disabled = true
	attack_button.disabled = true
	defend_button.disabled = true

func enemy_death(gold_award, xp_award):
	current_enemy = null
	gold += gold_award
	xp += xp_award
	emit_signal("gold_change", gold)
	emit_signal("xp_change", xp)

func reset_attack():
	attack_button.frame = 0
	current_state = state.IDLE

func purchase_weapon(index):
	weapon = GameState.weapons[index]
	GameState.weapons = GameState.weapons.slice(index + 1, GameState.weapons.size() - 1)
	gold -= weapon.price
	emit_signal("gold_change", gold)
	weapon_sprite.texture = weapon.texture

func purchase_armor(index):
	armor = GameState.armors[index]
	GameState.armors = GameState.armors.slice(index + 1, GameState.armors.size() - 1)
	gold -= armor.price
	emit_signal("gold_change", gold)
	armor_sprite.texture = armor.texture
			
