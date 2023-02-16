extends Control

onready var return_button = $Background/ReturnButton
onready var next_item_button = $Background/NextItemButton
onready var prev_item_button = $Background/PrevItemButton
onready var stat_1_label = $Background/Stat1Label
onready var stat_2_label = $Background/Stat2Label
onready var purchase_button = $Background/PurchaseButton
onready var req_1_label = $Background/PurchaseButton/Req1Label
onready var req_2_label = $Background/PurchaseButton/Req2Label
onready var req_3_label = $Background/PurchaseButton/Req3Label

enum ShopType {BLACKSMITH, ARMORY, ALCHIMIST, LIBRARY}

export(NodePath) var transition_animation_path = null
export(NodePath) var player_path = null
export(ShopType) var shop_type = ShopType.BLACKSMITH

var transition_animation = null
var player = null
var current_index = 0
var current_dmg
var current_price

func _ready():
	transition_animation = get_node(transition_animation_path)
	player = get_node(player_path)
	return_button.connect("pressed", self, "on_return_button")
	next_item_button.connect("pressed", self, "on_next_press")
	prev_item_button.connect("pressed", self, "on_prev_press")
	purchase_button.connect("pressed", self, "on_purchase_press")

func on_return_button():
	match shop_type:
		ShopType.BLACKSMITH:
			transition_animation.play("LeaveBlacksmith")
		ShopType.ARMORY:
			transition_animation.play("LeaveArmory")
		ShopType.ALCHIMIST:
			transition_animation.play("LeaveAlchimist")	
		ShopType.LIBRARY:
			transition_animation.play("LeaveLibrary")	

func refresh(skip_gold = false):
	prev_item_button.set_visible(current_index > 0)
	if not skip_gold:
		stat_2_label.text = str(player.gold)
	match shop_type:
		ShopType.BLACKSMITH:
			refresh_blacksmith()
		ShopType.ARMORY:
			refresh_armory()
		ShopType.ALCHIMIST:
			refresh_alchimist()
		ShopType.LIBRARY:
			refresh_library()

func refresh_blacksmith():
	stat_1_label.text = player.weapon + " (" + DiceHelper.get_range(player.weapon) + ")"
	next_item_button.set_visible(current_index < GameState.weapons.size() - 1)	
	if GameState.weapons.size() > 0:
		var item_dmg = GameState.weapons[current_index].damage
		req_1_label.text = item_dmg + " (" + DiceHelper.get_range(item_dmg) + ")"
		req_2_label.text = str(GameState.weapons[current_index].price)
		purchase_button.disabled = GameState.weapons[current_index].price > player.gold
	else:
		purchase_button.visible = false

func refresh_armory():
	stat_1_label.text = str(player.armor)
	next_item_button.set_visible(current_index < GameState.armors.size() - 1)
	if GameState.armors.size() > 0:
		req_1_label.text = str(GameState.armors[current_index].armor)
		req_2_label.text = str(GameState.armors[current_index].price)
		purchase_button.disabled = GameState.armors[current_index].price > player.gold
	else:
		purchase_button.visible = false
	
func refresh_alchimist():
	stat_1_label.text = str(player.max_health) + " HP"
	next_item_button.set_visible(false)
	purchase_button.visible = player.has_potion == false
	req_2_label.text = str(player.composition * 10)
	purchase_button.disabled = player.composition * 10 > player.gold

func refresh_library():
	var price = GameState.skills[current_index].price
	var lvl_req = GameState.skills[current_index].xp
	var has_skill = player.skills.has(GameState.skills[current_index].title)
	stat_1_label.text = "lvl " + str(player.xp_level)
	next_item_button.set_visible(current_index < GameState.skills.size() - 1)
	req_1_label.text = GameState.skills[current_index].title
	if has_skill:
		req_1_label.text = "learned"
	req_2_label.text = str(price)
	req_3_label.text = str(lvl_req)
	purchase_button.disabled = has_skill or player.xp_level < lvl_req or player.gold < price

func on_next_press():
	current_index += 1
	refresh()

func on_prev_press():
	current_index -= 1
	refresh()

func on_purchase_press():
	var price = 0
	match shop_type:
		ShopType.BLACKSMITH:
			price = GameState.weapons[current_index].price
			player.weapon = GameState.weapons[current_index].damage
			GameState.weapons = GameState.weapons.slice(current_index + 1, GameState.weapons.size() - 1)
		ShopType.ARMORY:
			price = GameState.armors[current_index].price
			player.armor = GameState.armors[current_index].armor
			GameState.armors = GameState.armors.slice(current_index + 1, GameState.armors.size() - 1)
		ShopType.ALCHIMIST:
			price = player.composition * 10
			player.has_potion = true
		ShopType.LIBRARY:
			price = GameState.skills[current_index].price
			player.skills.append(GameState.skills[current_index].title)
			GameState.skills = GameState.skills.slice(0, current_index) + GameState.skills.slice(current_index + 1, GameState.skills.size() - 1)
	player.gold -= price
	current_index = 0
	refresh()
