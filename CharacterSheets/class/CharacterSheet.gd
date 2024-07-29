extends Resource

class_name CharacterSheet 

signal HP_changed
signal DT_changed
#signal player_died
signal Dodge_changed
signal limb_hp_changed
signal limb_dead
signal armor_equipped(currently_equipped_slot: String, item_to_equip: Item)
signal weapon_equipped(currently_equipped_slot: String, item_to_equip: Item)
signal stat_changed(current_stat_value: int)
signal encumbrance_changed(current_encumbrance: int)

@export var class_title: String
## Stats

var stat_dictionary: Dictionary ={
	"Vitality": 0,
	"Coordination": 0,
	"Eloquence": 0,
	"Intuition": 0,
	"Brilliance": 0,
	"Empathy": 0
	
}

func _change_stat(input_name: String, input_value: int) -> void:
	stat_dictionary[input_name] += input_value
	stat_changed.emit(stat_dictionary[input_name]) #TODO connect this to the ui
	
func _get_stat(input_name: String) -> int:
	return stat_dictionary[input_name]

@export var stat_spread: Array[int]
@export var VITALITY: int #BODYBUILDER 
@export var COORDINATION: int #BALLERINA
@export var ELOQUENCE: int  #POLITICIAN
@export var INTUITION: int #LIBRARIAN/SAVANT
@export var BRILLIANCE: int #SOCIOPATH
@export var EMPATHY: int #GURU


# if limb hp changes,
# change hp
var max_HP: int:  get = get_max_HP #, set = set_max_HP,
var HP: int :get = get_HP #,set = set_HP 


## Derived Features: Dodge,
var dodge_dice: int: set = set_dodge_dice, get = get_dodge_dice
var dodge: int: get = get_dodge

var stamina_dice: int: set = set_stamina_dice, get = get_stamina_dice
var stamina: int: get = get_stamina
var DT: int:  get = get_DT#, set = set_DT,
var hard_DT: int: set = set_hard_DT, get = get_hard_DT
var soft_DT: int: set = set_soft_DT, get = get_soft_DT

## Derived Stats/Skill



## Arms
@export var right_arm_dice: Array[int] 
@export var equipped_right_arm_weapon: Weapon
@export var equipped_right_arm_armor: Armor

@export var left_arm_dice: Array[int]
@export var equipped_left_arm_weapon: Weapon
@export var equipped_left_arm_armor: Armor
## Legs
@export var right_leg_dice: Array[int]
@export var equipped_right_leg_armor: Armor

@export var left_leg_dice: Array[int]
@export var equipped_left_leg_armor: Armor
#affects dodge

## Torso
@export var torso_dice: Array[int]
@export var equipped_torso_armor: Armor


## Head
@export var head_dice: Array[int]
@export var equipped_helmet: Armor
#hitting this deals bonus HP damage?

var encumbrance: int
@export var name: String

var limb_dictionary: Dictionary = { #sets the current hp, changing these won't change the original values?
	"head":head_dice,
	"torso":torso_dice,
	"right_arm": right_arm_dice,
	"left_arm": left_arm_dice,
	"right_leg": right_leg_dice,
	"left_leg": left_leg_dice,
}


@export var equipped_armor_dictionary: Dictionary = { #sets the current hp, changing these won't change the original values?
	"head": null,
	"torso":null,
	"right_arm": null,
	"left_arm": null,
	"right_leg": null,
	"left_leg": null,
}

@export var equipped_weapon_dictionary: Dictionary = {
	"right_arm": null,
	"left_arm": null
}

#grab max hp
# = limb hp


func set_HP() -> void: 
	#print(get_HP())
	
	var temp_hp_count:int = 0 
	#print(limb_dictionary)
	for limb_name in limb_dictionary.keys(): # each limb will call this function to change the HP
		temp_hp_count += get_limb_hp_from_dice(limb_dictionary[limb_name]) #first element is the curent hp, 2nd is the max
	HP = clamp(temp_hp_count,0,999)
	HP_changed.emit(HP)

	#print(get_HP())
	#print("stop")
	
	#if get_DT() >= HP:
		#player_died.emit()
	
func get_HP() -> int:
	return HP


func initiate_char() -> void:
	#limb_dictionary["head"] = head_dice.duplicate(true)
	#limb_dictionary["torso"] = torso_dice.duplicate(true)
	#limb_dictionary["right_arm"] = right_arm_dice.duplicate(true)
	#limb_dictionary["left_arm"] = left_arm_dice.duplicate(true)
	#limb_dictionary["right_leg"] = right_leg_dice.duplicate(true)
	#limb_dictionary["left_leg"] = left_leg_dice.duplicate(true)
	
	
	
	var stat_idx: int = 0
	for stat_value: String in stat_dictionary.keys():
		
		stat_dictionary[stat_value] = stat_spread[stat_idx]
		stat_idx += 1
	
	var max_head_hp: int = BRILLIANCE/2 + EMPATHY/2 + INTUITION/2 + .5*VITALITY
	var head_hp: int #= clampi(0,0,max_head_hp) not clamping these values so they can increase based on bonuses

	var max_torso_hp: int = VITALITY
	var torso_hp: int #= clampi(0,0,max_torso_hp)

	var max_right_arm_hp: int = VITALITY/2 + COORDINATION/2
	var right_arm_hp:int# = clampi(0,0,max_right_arm_hp)

	var max_left_arm_hp: int = VITALITY/2  + COORDINATION/2
	var left_arm_hp: int #= clampi(0,0,max_left_arm_hp)

	var max_right_leg_hp: int = VITALITY/2 + COORDINATION/2
	var right_leg_hp: int #= clampi(0,0,max_right_leg_hp)

	var max_left_leg_hp: int = VITALITY/2  + COORDINATION/2
	var left_leg_hp: int #= clampi(0,0,max_left_leg_hp)
	
	#TODO how is the dice split
	#TODO Character Creation Screen
	#should a combo of vit/class determine the max dice?
	# warrior, 6 vit limbs may have a max dice of d6? 
	# vit determines the largest dice size OR the number of dice in each limb? (or vit bonus adds to each dice limb?)
	# class determines what? should influence the growth of dice, maybe the base
	# secondary stats determine what for their respective limbs?
	

	
	limb_dictionary["head"] = head_dice.duplicate(true)
	limb_dictionary["torso"] = torso_dice.duplicate(true)
	limb_dictionary["right_arm"] = right_arm_dice.duplicate(true)
	limb_dictionary["left_arm"] = left_arm_dice.duplicate(true)
	limb_dictionary["right_leg"] = right_leg_dice.duplicate(true)
	limb_dictionary["left_leg"] = left_leg_dice.duplicate(true)
	
	
	
	equip_item("right_hand",equipped_right_arm_weapon.duplicate(true))
	#equip_item("left_hand",equipped_left_arm_weapon.duplicate(true))
	equip_item("head",equipped_helmet.duplicate(true))
	equip_item("right_arm",equipped_right_arm_armor.duplicate(true))
	equip_item("left_arm",equipped_left_arm_armor.duplicate(true))
	

	#equipped_weapon_dictionary["right_arm"] = equipped_right_arm_weapon
	#equipped_weapon_dictionary["left_arm"] = equipped_left_arm_weapon
	#equipped_armor_dictionary["head"] = equipped_helmet_dice.duplicate(true)
	#equipped_armor_dictionary["torso"] = equipped_torso_armor_dice.duplicate(true)
	#equipped_armor_dictionary["right_arm"] = equipped_right_arm_armor_dice.duplicate(true)
	#equipped_armor_dictionary["left_arm"] = equipped_left_arm_armor_dice.duplicate(true)
	#equipped_armor_dictionary["right_leg"] = right_leg_armor_dice.duplicate(true)
	#equipped_armor_dictionary["left_leg"] = left_leg_armor_dice.duplicate(true)

func calc_encumbrance() -> void:
	encumbrance = 0
	for armor: Armor in equipped_armor_dictionary.values():
		encumbrance += armor.encumbrance
	encumbrance_changed.emit(encumbrance)

func get_limb_hp_from_dice(limb_array: Array) -> int:
	var hp_from_limb: int = 0
	for dice in limb_array:
		hp_from_limb += dice
	return hp_from_limb

func equip_item(limb: String, item_to_equip: Item) -> void:
	
	if item_to_equip is Armor:
		equipped_armor_dictionary[limb] = item_to_equip
		item_to_equip.currently_equipped_slot = limb
		calc_encumbrance()
		#print_debug(limb)
		#armor_equipped.emit(limb, item_to_equip)
		
	elif item_to_equip is Weapon:
		equipped_weapon_dictionary[limb] = item_to_equip
		item_to_equip.currently_equipped_slot = limb
		
		#weapon_equipped.emit(limb, item_to_equip)

func unequip_item(limb: String) -> void:
	if limb == "left_arm" or limb == "right_arm":
		equipped_weapon_dictionary[limb] = null
	else:
		equipped_armor_dictionary[limb] = null
		calc_encumbrance()
	


		
	

func set_max_HP() -> void:
	#var placeholder_max_HP: int = VITALITY*3
	
	var temp_max_HP_count: int = 0
	for limb_name in limb_dictionary.keys(): # each limb will call this function to change the HP
		temp_max_HP_count += get_limb_hp_from_dice(limb_dictionary[limb_name])
	max_HP = clamp(temp_max_HP_count,0,temp_max_HP_count) 
	#max_HP_changed.emit(max_HP)

func get_max_HP() -> int:
	return max_HP

func get_limb_hp(limb: String) -> Variant:
	if limb_dictionary.has(limb):
		return limb_dictionary[limb] #returns limb dice array
	else:
		print("limb/key not found in dictionary: ", limb)
		return null

func set_dodge_dice(value: int) -> void:
	dodge_dice = clampi((value - encumbrance)*2,0,9999) #cap ddoge?

func get_dodge_dice() -> int:
	return dodge_dice


func set_dodge() -> void: 
	var test2 = get_limb_hp_from_dice(limb_dictionary["left_leg"]) 
	var test3 = get_limb_hp_from_dice(limb_dictionary["right_leg"])
	var test4 = get_limb_hp_from_dice(right_leg_dice)
	var test5 = get_limb_hp_from_dice(left_leg_dice)
	var test : float = (float(test2 + test3)/float(test4 + test5))
	dodge = floori(test*get_dodge_dice())
	#print(test2)
	#print(test)
	Dodge_changed.emit()
	#TODO lose AC bonus from coordination if you have no weapon
func get_dodge() -> int:
	return dodge
#split into hard and soft DT
#DT = hard DT + soft DT
#hard DT = running value of DT increases applied to you
#soft DT = how stamina affects DT
#set_DT() runs after either of the above are updated


func set_DT():
	DT = clamp((get_hard_DT() + get_soft_DT()),0,get_max_HP())  #+ 40% of max stamina #MAX DT should be equal to max HP
	DT_changed.emit(DT)
	#if DT >= get_HP():
		#player_died.emit()

func get_DT() -> int:
	return DT

func set_hard_DT(value: int) -> void:
	hard_DT += value # increase hardDT

func get_hard_DT() -> int:
	return hard_DT
	
func set_soft_DT(value: int) -> void:
	soft_DT = value

func get_soft_DT() -> int:
	return soft_DT


func set_stamina_dice(value: int) -> void:
	stamina_dice = clampi(value,0,9999)

func get_stamina_dice() -> int:
	return stamina_dice

func set_stamina() -> void:
	var test = get_limb_hp_from_dice(limb_dictionary["torso"])
	var test2 = get_limb_hp_from_dice(torso_dice)
	var test3: float = ( float(test)/float(test2))
	stamina = floori(test3 * get_stamina_dice())
	var soft_DT_input:int  = get_max_HP() * .4 - get_stamina()
	set_soft_DT(soft_DT_input)
	set_DT()

	
func get_stamina() -> int:
	return stamina
#var stamina_dice: int = set set_stamina_dice, get = get_stamina_dice
#var stamina: int: get = get_stamina

func swap_elements_in_array(array: Array) -> void:
	for element in array:
		if element == 72:
			array[array.find(element)] = 5
	print(array)
	
func reset_right_arm_dice(original_array: Array[int]) -> void:
	right_arm_dice.clear()
	right_arm_dice.append_array(original_array)

func reduce_each_element_by_one_left_to_right(limb_dice_array: Array, damage: int) -> void:
	#while there are still damage points
	#go to the next element in the array, subtract 1
	#at the end of the array, go back to the first
	if limb_dice_array.is_empty(): #limb is dead, end combat
		return
	
	var index: int = 0
	while damage > 0 and limb_dice_array.size() > 0: #keeps going while there is still damage. ends if the damage is dealt or the array is empty
		
		if index >= limb_dice_array.size():
			index = 0 #reset the index to loop back to the start of the array
			
		limb_dice_array[index] -= 1
		damage -= 1
			
			
		if limb_dice_array[index] == 0: #remove the empty dice from the array
			limb_dice_array.remove_at(index)
			
		else:
			index += 1
		
func reduce_max_element(limb_dice_array: Array, damage: int) -> void: # the highest dice gets targeted
	while damage > 0 and limb_dice_array.size() > 0:
		var max_value: int = limb_dice_array[0]
		var max_index: int = 0
		
		for i in range(limb_dice_array.size()): # find the index with the highest value in the array
			if limb_dice_array[i] > max_value:
				max_value = limb_dice_array[i]
				max_index = i
		
		limb_dice_array[max_index] -= 1
		damage -= 1
		
		if limb_dice_array[max_index] == 0: #remove the empty dice from the array
			limb_dice_array.remove_at(max_index)
			

func focus_max_element(limb_dice_array: Array, damage: int) -> void:
	while damage > 0 and limb_dice_array.size() > 0:
		var max_value: int = limb_dice_array[0]
		var max_index: int = 0
		
		for i in range(limb_dice_array.size()):
			if limb_dice_array[i] > max_value:
				max_value = limb_dice_array[i]
				max_index = i
		
		var amount_to_subtract: int = mini(damage, limb_dice_array[max_index])
		#print(get_HP())
		#print(limb_dice_array)
		#print(damage)
		limb_dice_array[max_index] -= amount_to_subtract
		#print(get_HP())
		#print(limb_dice_array)
		#limb_hp_changed.emit(value) #dice pool changes with hp
		 #change the hp after taking damage
		damage -= amount_to_subtract
		if limb_dice_array[max_index] == 0: #remove the empty dice from the array
			limb_dice_array.remove_at(max_index)
	
	#if limb_dice_array.size() == 0:
		##print("limb dead")
		#limb_dead.emit(limb_dice_array) #limb dead, stop targeting
		
		

func take_damage_type_1(limb_dice_array: Array, damage: int) -> void: 
	#remove health from the first element in the array
	if limb_dice_array.is_empty(): #the array is empty
		print("the arm is depleted")
		return
		
	#elif limb_dice_array[0] == 0: #remove the first element
		#limb_dice_array.pop_front()
	var limb_dice_array_copy: Array = []
	var temp_damage_counter: int = 0
	limb_dice_array_copy.append_array(limb_dice_array)
	
	if damage > limb_dice_array[0]:
		for element in limb_dice_array_copy: #go through each element in the array
			temp_damage_counter += element
			if damage == temp_damage_counter:# if the damage is = to the dice array element, reduce it to 0 and remove
				limb_dice_array[limb_dice_array.find(element)] = 0
				limb_dice_array.pop_at(limb_dice_array.find(element)) #remove this element
				break
				
			elif damage < temp_damage_counter: # if its less than, subtract the damage and move on
				limb_dice_array[limb_dice_array.find(element)] = temp_damage_counter - damage
				break
			
			else: #damage > the current damage counter
				#[ 3 3 3] go through
				limb_dice_array.pop_at(limb_dice_array.find(element)) #remove the element that is added to the damage counter
	
	elif damage == limb_dice_array[0]:
		limb_dice_array.pop_front()
	
	else: #damage < dice
		limb_dice_array[0] -= damage

#warrior
# [ 1d3 1d6 1d3 1d6 ] WD[ 2d3 ] WA[ 1d8 ]
# 000 | 000000 | 000 | 000000 | class determines the limb split
# [ 3 6 3 6 ] arms [ 5 ] Armor D/A
# [ 5 5 5 5 ] legs [ 5 ] Armor
# [ 2 2 3 ] Head [ 4 5 5 ] Armor
# [ 5 6 6 ] Torso [ 4 5 7 ] Armor
# left weapon = shield -> 000 | 000 | D[ 2d3 ]
# right weapon = sword ->  00000000 | A[ 1d8 ] 

# base arms | class | left_weapon | right_weapon

#thief
# HP = arms + legs + head + torso
# [ 1d3 2d2 1d3 2d2 ] WD/A[ 2d3 ] WD/A[ 2d3 ]
# [ 3 3 2 3 3 2 ] arms [ 2 2 ] Armor 1d2 for each limb
# [ 3 4 5 3 4 5 ] legs [ 2 2 ] Armor 1d2 for each limb
# [ 3 3 4 ] Head [ 0 ] Armor
# [ 3 3 3 3 3 ] Torso [ 4 ] Armor


# dagger ->  000 | 000
# dagger ->  000 | 000
# base arms | class | left_weapon | right_weapon
