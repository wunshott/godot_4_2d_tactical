extends Node


class_name Stats
#put all the character stat stuff in this script
signal fill_hud(stamina)
signal stamina_used_for_moevement(stamina_changed)
signal armor_damaged(damage:int, armor:Armor)
signal string_for_combat_box(text: String, TextType: String)
signal stamina_to_send(current_stamina:int)
signal stamina_to_send_to_hud(current_stamina:int) 
signal _send_max_stamina_to_char_sheet(max_stamina: int)
signal THC_to_send(current_hit_chance:int)

@onready var inventory = $"../Inventory"

#TODO make this a separate scene

@export var CharacterSheetData: CharacterSheet
@export var Default_Stamina_Burn_Movement_rate: int = 3




#Coordination
var speed: int #free_movement
var movement_pool: int: set = _set_movement_pool, get = _get_movement_pool
var movement_exertion_cost: int # amount of stamina to drain per tile outside of movement
var coordination_stat_bonus: int

var dodge_chance: int
#Armor value

@export var test_max_movement: int = 100


## SETTERS GETTERS

#movement
func _set_movement_pool(value: int):
	movement_pool = clamp(value, 0, test_max_movement)
	
	
func _get_movement_pool() -> int:
	return movement_pool


func populate_character():
	CharacterSheetData.set_max_stamina(CharacterSheetData.VITALITY*2)
	CharacterSheetData.set_stamina(CharacterSheetData.get_max_stamina())
	
	CharacterSheetData.initialize_limbs_HP()
	
	
	CharacterSheetData.set_DT(0) #TODO starter DT value?
	
	CharacterSheetData.set_dodge_dice(CharacterSheetData.get_stat_bonus(CharacterSheetData.COORDINATION))
	#possible to rebalance game. increase base dodge die
	

	var max_head_hp: int = CharacterSheetData.BRILLIANCE/2 + CharacterSheetData.EMPATHY/2 + CharacterSheetData.INTUITION/2 + .5*CharacterSheetData.VITALITY

	var max_torso_hp: int = CharacterSheetData.VITALITY*1.5

	var max_right_arm_hp: int = CharacterSheetData.VITALITY/2 + CharacterSheetData.COORDINATION/2

	var max_left_arm_hp: int = CharacterSheetData.VITALITY/2 + CharacterSheetData.COORDINATION/2

	var max_right_leg_hp: int = CharacterSheetData.VITALITY/2 + CharacterSheetData.COORDINATION/2

	var max_left_leg_hp: int = CharacterSheetData.VITALITY/2 + CharacterSheetData.COORDINATION/2
	
	var limb_dictionary: Dictionary = {
		"head":[max_head_hp],
		"torso":[max_torso_hp],
		"right_arm": [max_right_arm_hp],
		"left_arm": [max_left_arm_hp],
		"right_leg": [max_right_leg_hp],
		"left_leg": [max_left_leg_hp],
	}
	
	#print(limb_dictionary)
	
	coordination_stat_bonus = CharacterSheetData.COORDINATION - 5 # replace 5 with the standard value for determining stat bonuses
	speed = 5 + coordination_stat_bonus
	#movement_pool = clampi(speed,0,text_max_movement)
	_set_movement_pool(speed)
	movement_exertion_cost = Default_Stamina_Burn_Movement_rate - floor(coordination_stat_bonus/2)
	
	
	
	
	fill_hud.emit(CharacterSheetData.get_stamina())

func _change_stamina_from_moving(stamina_burned) -> void:
	CharacterSheetData.set_stamina(CharacterSheetData.get_stamina() - stamina_burned)
	stamina_used_for_moevement.emit(stamina_burned)


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO ensure the appropriate values are passed to the vats_menu
# TODO take damage, drain stamin, do actions, etc should be from the stats script


func _on_button_pressed():
	CharacterSheetData.remove_stamina(1)

func _on_damage_head_pressed():
	CharacterSheetData.damamge_limb("head",1)


func _on_damage_torso_pressed():
	CharacterSheetData.damamge_limb("torso",1)
