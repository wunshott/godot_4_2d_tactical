extends Node

signal send_attack_hud_actions(attack_action_array:Array[Action], weapon_hit_bonus:int,weapon_icon:Texture2D, attacker_base_hit_bonus:int)
signal send_armor_damage_to_hud(ArmorDamage: int, ArmorLimb: String, ArmorBrokenBool: bool)
signal send_invetory_to_hud(player_inventory: Array)

@export var equipped_weapon_dict: Dictionary
@export var equipped_armor_dict: Dictionary 
@export var inventory: Array[Item] 

@onready var inventory_Node = $"."
@onready var stats = $"../Stats"
const FIST = preload("res://top_down/Items/Weapons/Fist.tres")

var hit_chance



# Called when the node enters the scene tree for the first time.
func _ready():
	send_invetory_to_hud.emit(inventory)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _equip_item(limb: String, item_to_be_equipped: Item) -> void:# sorts the item by armor or weapon
	if item_to_be_equipped is Weapon:
		var item_index_inventory = inventory.find(item_to_be_equipped)
		_equip_weapon(limb,inventory[item_index_inventory])
		inventory.erase(item_to_be_equipped)
		
	elif  item_to_be_equipped is Armor:
		var item_index_inventory = inventory.find(item_to_be_equipped)
		_equip_armor(limb, inventory[item_index_inventory])
		inventory.erase(item_to_be_equipped)
	else: # the item is not a weapon or armor, its a normal item (gem or something)
		print("attempted item is not weapon or armor")
		return 


func _unequip_item(limb: String, item_to_be_unequipped: Item) -> void:
	if item_to_be_unequipped is Weapon:
		_unequip_weapon(limb, item_to_be_unequipped)
	
	elif item_to_be_unequipped is Armor:
		_unequip_armor(limb, item_to_be_unequipped)
		
	
	else: # the item to unequip isn't armor or a weapon
		print("attempted item is not weapon or armor")
		pass

func _unequip_armor(limb:String, ArmorToBeUnequipped: Armor) -> void:
	inventory.append(ArmorToBeUnequipped)
	equipped_armor_dict.erase(limb)


func _unequip_weapon(limb:String, WeaponToBeUnequipped: Weapon) -> void:
	inventory.append(WeaponToBeUnequipped)
	equipped_weapon_dict.erase(limb)
	equipped_weapon_dict[limb] = FIST

func _equip_armor(limb: String, ArmorToBeEquipped: Armor) -> void: #for player only
	equipped_armor_dict[limb] = ArmorToBeEquipped

func _equip_weapon(limb: String, WeaponToBeEquipped: Weapon) -> void:
	#if !WeaponToBeEquipped:
		#equipped_weapon_dict[limb] = null
		#return
	equipped_weapon_dict[limb] = WeaponToBeEquipped



func _get_item_from_inventory(item_name: String):
	return inventory_Node.Inventory_Array.find(item_name)

func _get_armor_(equip_slot:String) -> Armor:
	var armor = equipped_armor_dict.get(equip_slot)
	return armor


func _on_attack_menu_request_player_attack_actions() -> void:
	var right_attack_action_array: Array[Action] = []
	var left_attack_action_array: Array[Action] = []
	var base_hit_chance = stats._get_hit_chance() #TODO figure out a better place to get the hit chance and send to dice roller. need to update
	for attacks in equipped_weapon_dict["RightHand"].Attacks:
		right_attack_action_array.append(attacks)
	for attacks in equipped_weapon_dict["LeftHand"].Attacks:
		left_attack_action_array.append(attacks) #TODO add a label to clarify which limb is attacking
	
	#also send the player base hit chance
	#also send the weapon's hit chance bonus
	
	
	send_attack_hud_actions.emit(right_attack_action_array,equipped_weapon_dict["RightHand"].hit_chance, equipped_weapon_dict["RightHand"].ItemSprite,
	base_hit_chance) 
	send_attack_hud_actions.emit(left_attack_action_array,equipped_weapon_dict["LeftHand"].hit_chance, equipped_weapon_dict["LeftHand"].ItemSprite,
	base_hit_chance)

func _on_stats_armor_damaged(armor_damage: int, limb_armor: Armor): 
	limb_armor._set_armor_hp(limb_armor._get_armor_hp() - armor_damage) #subtract damage from armor hp
	_send_updated_armor_to_vats()
	var armor_broken_bool: bool = false
	if limb_armor._get_armor_hp() > 0:
		send_armor_damage_to_hud.emit(armor_damage, limb_armor.ItemName,armor_broken_bool)
	else:  #TODO if armor is 0, send a special message
		armor_broken_bool = true
		send_armor_damage_to_hud.emit(armor_damage, limb_armor.ItemName, armor_broken_bool)
	
func _send_updated_armor_to_vats() -> void:
	get_parent()._send_AC_info_to_vats() #get's the parent function to send the armor info to the vats menu


func _on_player_stats_armor_damaged(armor_damage: int, limb_armor: Armor): 
	limb_armor._set_armor_hp(limb_armor._get_armor_hp() - armor_damage) #subtract damage from armor hp
	var armor_broken_bool: bool = false
	if limb_armor._get_armor_hp() > 0:
		send_armor_damage_to_hud.emit(armor_damage, limb_armor.ItemName,armor_broken_bool)
	else:  #TODO if armor is 0, send a special message
		armor_broken_bool = true
		send_armor_damage_to_hud.emit(armor_damage, limb_armor.ItemName, armor_broken_bool)
