extends Control

onready var return_button = $Background/ReturnButton
onready var stat_1_label = $Background/Stat1Label
onready var stat_2_label = $Background/Stat2Label
onready var purchase_button = $Background/PurchaseButton
onready var req_1_label = $Background/PurchaseButton/Req1Label
onready var req_2_label = $Background/PurchaseButton/Req2Label
onready var req_3_label = $Background/PurchaseButton/Req3Label
onready var item_label = $Background/PurchaseButton/ItemLabel
onready var stat_1_label2 = $Background/Stat1Label2

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
	purchase_button.connect("pressed", self, "on_purchase_press")
	player.connect("gold_change", self, "on_hero_gold_change")
	stat_2_label.set_value(player.gold)

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
	stat_1_label.text = DiceHelper.get_range(player.weapon.damage)
	if GameState.weapons.size() > 0:
		var item_dmg = GameState.weapons[current_index].damage
		req_1_label.text = item_dmg + " (" + DiceHelper.get_range(item_dmg) + ")"
		req_2_label.text = str(GameState.weapons[current_index].price)
		item_label.text = GameState.weapons[current_index].name
		purchase_button.disabled = GameState.weapons[current_index].price > player.gold
	else:
		purchase_button.visible = false

func refresh_armory():
	stat_1_label.text = "-" + str(player.armor.effect) + " dmg"
	if GameState.armors.size() > 0:
		req_1_label.text = "-" + str(GameState.armors[current_index].effect) + " dmg"
		req_2_label.text = str(GameState.armors[current_index].price)
		item_label.text = GameState.armors[current_index].name		
		purchase_button.disabled = GameState.armors[current_index].price > player.gold
	else:
		purchase_button.visible = false
	
func refresh_alchimist():
	stat_1_label.text = str(player.max_health) + " HP"
	purchase_button.visible = player.has_potion == false
	req_2_label.text = str(player.get_potion_price())
	purchase_button.disabled = player.get_potion_price() > player.gold

func refresh_library():
	if GameState.skills.size() > 0:
		var price = GameState.skills[current_index].price
		var lvl_req = GameState.skills[current_index].xp
		stat_1_label2.text = "lvl " + str(player.xp_level)
		item_label.text = GameState.skills[current_index].title
		req_2_label.text = str(price)
		req_3_label.text = str(lvl_req)
		purchase_button.disabled = player.xp_level < lvl_req or player.gold < price
	else:
		purchase_button.visible = false

func on_hero_gold_change(gold):
	stat_2_label.set_value(gold)
	refresh(true)

func on_purchase_press():
	match shop_type:
		ShopType.BLACKSMITH:
			player.purchase_weapon(current_index)
		ShopType.ARMORY:
			player.purchase_armor(current_index)
		ShopType.ALCHIMIST:
			player.purchase_potion()
		ShopType.LIBRARY:
			match GameState.skills[current_index].title:
				"multicombo":
					find_node("ComboInfoPanel").visible = true
				"reflect":
					find_node("ReflectInfoPanel").visible = true
				"berserk":
					find_node("BerserkInfoPanel").visible = true
			player.purchase_skill(current_index)
	current_index = 0
	refresh()
