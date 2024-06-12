extends Resource

class_name Class

signal HP_changed
signal limb_hp_changed
signal limb_dead

#TODO if the limb has no hp, deal double damage to top HP?
@export var class_title: String

## Arms
@export var right_arm_dice: Array[int] 
@export var right_weapon: Array[int]
@export var equipped_right_arm_armor_dice: Array[int] 

@export var left_arm_dice: Array[int]
@export var left_weapon: Array[int]
@export var equipped_left_arm_armor_dice: Array[int] 


## Legs
@export var right_leg_dice: Array[int]
@export var right_leg_armor_dice: Array[int]

@export var left_leg_dice: Array[int]
@export var left_leg_armor_dice: Array[int]
#affects dodge

## Torso
@export var torso_dice: Array[int]
@export var equipped_torso_armor_dice: Array[int]


## Head
@export var head_dice: Array[int]
@export var equipped_helmet_dice: Array[int]
#hitting this deals bonus HP damage?

var limb_dictionary: Dictionary = { #sets the current hp, changing these won't change the original values?
	"head":head_dice,
	"torso":torso_dice,
	"right_arm": right_arm_dice,
	"left_arm": left_arm_dice,
	"right_leg": right_leg_dice,
	"left_leg": left_leg_dice,
}

var equipped_armor_dictionary: Dictionary = { #sets the current hp, changing these won't change the original values?
	"head": equipped_helmet_dice,
	"torso":equipped_torso_armor_dice,
	"right_arm": equipped_right_arm_armor_dice,
	"left_arm": equipped_left_arm_armor_dice,
	"right_leg": right_leg_armor_dice,
	"left_leg": left_leg_armor_dice,
}

#grab max hp
# = limb hp

# if limb hp changes,
# change hp
var max_HP: int:  get = get_max_HP #, set = set_max_HP,
var HP: int :get = get_HP #,set = set_HP #TODO remove the set/get if hp still has issues changing

func set_HP() -> void: #TODO troubleshoot by asking for an input: input_limb_dict: Dictionary
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

func initialize_limb_hp() -> void:
	limb_dictionary["head"] = head_dice.duplicate(true)
	limb_dictionary["torso"] = torso_dice.duplicate(true)
	limb_dictionary["right_arm"] = right_arm_dice.duplicate(true)
	limb_dictionary["left_arm"] = left_arm_dice.duplicate(true)
	limb_dictionary["right_leg"] = right_leg_dice.duplicate(true)
	limb_dictionary["left_leg"] = left_leg_dice.duplicate(true)
	
	equipped_armor_dictionary["head"] = equipped_helmet_dice.duplicate(true)
	equipped_armor_dictionary["torso"] = equipped_torso_armor_dice.duplicate(true)
	equipped_armor_dictionary["right_arm"] = equipped_right_arm_armor_dice.duplicate(true)
	equipped_armor_dictionary["left_arm"] = equipped_left_arm_armor_dice.duplicate(true)
	equipped_armor_dictionary["right_leg"] = right_leg_armor_dice.duplicate(true)
	equipped_armor_dictionary["left_leg"] = left_leg_armor_dice.duplicate(true)

func get_limb_hp_from_dice(limb_array: Array) -> int:
	var hp_from_limb: int = 0
	for dice in limb_array:
		hp_from_limb += dice
	return hp_from_limb

func set_max_HP() -> void:
	#var placeholder_max_HP: int = VITALITY*3
	
	var temp_max_HP_count: int
	for limb_name in limb_dictionary.keys(): # each limb will call this function to change the HP
		temp_max_HP_count += get_limb_hp_from_dice(limb_dictionary[limb_name])
	max_HP = clamp(temp_max_HP_count,0,temp_max_HP_count) #TODO should this be a function of limb max hp?
	#max_HP_changed.emit(max_HP)

func get_max_HP() -> int:
	return max_HP

func get_limb_hp(limb: String) -> Variant:
	if limb_dictionary.has(limb):
		return limb_dictionary[limb] #returns limb dice array
	else:
		print("limb/key not found in dictionary: ", limb)
		return null

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
		#set_HP() #TODO HP BAR NOT UPDATING PROPERLY. YOU CAN'T CALL IT INSIDE THIS SCRIPT. NEEDS TO BE REFERENCED OUTSIDE?
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
	var limb_dice_array_copy: Array
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
