extends Item


class_name Weapon

#@export var WeaponName: String = ""
@export var WeaponTtype: String = ""
#@export var WeaponIcon: Texture2D
@export var Attacks: Array[Action]
@export var currently_equipped_hand:String
@export var weapon_hit_die_amount: int #
<<<<<<< Updated upstream
=======
@export var weapon_hit_die: Array[int]#

@export var weapon_success_array: Array[int]
@export var weapon_crit_array: Array[int]

@export var defense_only_dice: bool
@export var weapon_graze: int

@export var crit_pattern_array: Array #TODO this array holds all the crit patterns for this weapon. will need to be resource files

var critical_sequences = {
	"twin_six": [6, 6],
	"three_of_a_kind": [3, 3, 3],
	"full_house": [3, 3, 4, 4, 4],
}

func is_critical_sequence(input_roll: Array[int]) -> bool: #checks all the sequences in critial sequence 
	for sequence in critical_sequences.values():
		if sequence_in_rolls(sequence,input_roll):
			return true
	return false
		
		
func sequence_in_rolls(sequence: Array[int], input_roll: Array[int]) -> bool: #checks if an array of rolls matches the given sequence
	var temp_rolls = input_roll.duplicate()
	for num in sequence:
		if num in temp_rolls:
			temp_rolls.erase(num)
		else:
			return false
	return true #returns true if all the numbers in the sequence match the input roll
		

func roll_dice_check_single_w(stamina_cost: int, stamina_dice_size: int) -> Dictionary:
	var output_dict: Dictionary
	var number_of_w: int
	var dice_result: Array[int]
	var w_result: Array[int]
	
	for idx: int in range(stamina_cost):
		var result = randi_range(1,stamina_dice_size)
		dice_result.append(result)
		if weapon_success_array.has(result) == true: #if it = -1, the array does not have the value
			number_of_w+=1
			w_result.append(result)
			
	
			
	#TODO dice roll and allow player to select W's for dice
	# allow player to select Ws
	# allow player to combine dice into Ws?
	
	
	output_dict["Ws"] = number_of_w
	output_dict["dice_result"] = dice_result
	output_dict["w_result"] = w_result
	output_dict["damage_dealt"] = sum_array(w_result)
	
	#print_debug("The dice result array is " + str(output_dict["dice_result"]) )
	#print_debug("the weapon rolls W on: " + str(weapon_success_array) )
	#print_debug("the dice roll resulted in " + str(output_dict["Ws"]) + " wins" )
	#print_debug("the damage is " + str(output_dict["damage_dealt"]))
	
	
	
	check_crit(dice_result)
	return output_dict
	

func apply_armor(armor_points: int, input_dice_roll:Array[int]) -> Array[int]:
	#var original_roll = input_dice_roll.duplicate()
	input_dice_roll.sort()
	input_dice_roll.reverse()
	for idx: int in range(input_dice_roll.size()):
		if armor_points == 0:
			break
		
		var original_roll = input_dice_roll[idx]
		
		if original_roll in weapon_success_array:
			#try to subtract points first
			while input_dice_roll[idx] in weapon_success_array and armor_points > 0:
				if input_dice_roll[idx] > 1: #if the dice roll is greater than 1, subtract until you run out of points, if the dice is 1 or the roll isn't a W
					input_dice_roll[idx] -=1
					armor_points -= 1
				else:
					break #stops the loop if the dice is already 1
			
			while input_dice_roll[idx] in weapon_success_array and armor_points > 0:
				if input_dice_roll[idx] < 6: #if the dice roll is less than 6
					input_dice_roll[idx] +=1
					armor_points -= 1
				else:
					break #stops the loop if the dice is already 1
		
		

	return input_dice_roll
	

func check_crit(result_dice_array: Array[int]) -> bool:
	result_dice_array.sort()
	weapon_crit_array.sort()
	
	for idx: int in weapon_crit_array:
		if result_dice_array.has(idx):
			result_dice_array.erase(idx)
		else:
			return false
	print_debug("critical_hit")
	return true
	

func sum_array(input_array: Array[int]) -> int:
	var array_sum: int 
	for idx: int in input_array:
		array_sum += idx
	
	return array_sum
>>>>>>> Stashed changes
