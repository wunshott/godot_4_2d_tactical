extends Node

class_name CombatHandler



var player_stamina_dice_size: int = 6
var player_stamina_dice_pool: Array[int]
var player_stamina: int = 20

var player_outcome_roll: Dictionary
var mob_outcome_roll: Dictionary

func _ready() -> void:
	randomize()




func compare_actions(player_dictionary: Dictionary, mob_dictionary: Dictionary) -> void:
	var action1: Action = player_dictionary["Action"]
	var action2: Action = mob_dictionary["Action"]
	#var player_output_action_roll: Array[int] = roll_dice_from_action(action1)
	#var mob_output_action_roll: Array[int] = roll_dice_from_action(action2)
	#
	var player_w_array: Array[int] #grab w array from their equipped weapon
	var mob_w_array: Array[int]
	#all ws from roll
	
	##Grapples are attack/defense/fakouts by of a grapple class. allows you to check both types
	print_debug("Player roll " +str(player_dictionary["dice_result"]))
	print_debug("Mob roll " +str(mob_dictionary["dice_result"]))
		#check if actions are A,D,F
		#TODO code combat
		#Armor has points you may use to modify and opponent's roll. subtract or defend
			#reducing the armor pips will reduce the armorp point pool
			#blocking damage causes enemy to lose stamina
			#stagger action to ease stagger status (if hit while staggered, maintain stagger. reduce stagger by for each turn you're not hit?)
			#equipped weapon determines your W number (for defense or attacK)
	match [action1.attack_type, action2.attack_type]:
		[Action.ATTACK_TYPE.Attack, Action.ATTACK_TYPE.Defend]:
			cancel_array(mob_dictionary,player_dictionary)
			print_debug("Player deals " + str(player_dictionary["damage_dealt"]) + " damage. Their W Array " + str(player_dictionary["w_result"]) )
			print_debug("Mob defends " + "Their W Array " + str(mob_dictionary["w_result"]) )

		[Action.ATTACK_TYPE.Attack, Action.ATTACK_TYPE.Attack]: # attack vs attack
			#compute damage after pass through armor and dodge.
			print_debug("Player deals " + str(player_dictionary["damage_dealt"]) + " damage. Their W Array " + str(player_dictionary["w_result"]) )
			print_debug("Mob deals " + str(mob_dictionary["damage_dealt"]) + " damage. Their W Array " + str(mob_dictionary["w_result"]) )

		[Action.ATTACK_TYPE.Attack, Action.ATTACK_TYPE.Fakeout]: # attack vs fakeout
			cancel_array(player_dictionary,mob_dictionary)
			print_debug("Player deals " + str(player_dictionary["damage_dealt"]) + " damage. Their W Array " + str(player_dictionary["w_result"]) )
			print_debug("Mob deals " + str(mob_dictionary["damage_dealt"]) + " damaage. Their W Array " + str(mob_dictionary["w_result"]) )
	
		[Action.ATTACK_TYPE.Defend, Action.ATTACK_TYPE.Defend]: # defense vs defense
			print_debug("Clash. Defend vs Defend")
		[Action.ATTACK_TYPE.Defend, Action.ATTACK_TYPE.Fakeout]: # defense vs fakeout
			cancel_array(mob_dictionary,player_dictionary)
			print_debug("Player defends. Their W array " + str(player_dictionary["w_result"]) )
			print_debug("Mob deals " + str(mob_dictionary["damage_dealt"]) + " damgage. Their W Array " + str(mob_dictionary["w_result"]) )
		[Action.ATTACK_TYPE.Defend, Action.ATTACK_TYPE.Attack]: # defense vs attack
			cancel_array(player_dictionary,mob_dictionary)
			print_debug("Player defends. Their W array " + str(player_dictionary["w_result"]) )
			print_debug("Mob deals " + str(mob_dictionary["damage_dealt"]) + " damage. Their W Array " + str(mob_dictionary["w_result"]) )
	
		[Action.ATTACK_TYPE.Fakeout, Action.ATTACK_TYPE.Fakeout]: # fakeout vs fakeout 
			print_debug("Clash. Fakeout vs Fakeout")
			
		[Action.ATTACK_TYPE.Fakeout, Action.ATTACK_TYPE.Defend]: # fakeout vs defend
			cancel_array(player_dictionary,mob_dictionary)
			print_debug("Player deals " + str(player_dictionary["damage_dealt"]) + " damage. Their W Array " + str(player_dictionary["w_result"]) )
			print_debug("Mob defends " +  str(player_dictionary["w_result"]) )

		[Action.ATTACK_TYPE.Fakeout, Action.ATTACK_TYPE.Attack]: # fakeout vs attack
			cancel_array(mob_dictionary,player_dictionary)
			print_debug("Player deals "+ str(player_dictionary["damage_dealt"]) + " damage. Their W Array " + str(player_dictionary["w_result"]) )
			print_debug("Mob deals "  + str(mob_dictionary["damage_dealt"]) + " damage. Their W Array " + str(mob_dictionary["w_result"]) )
	

func cancel_array(canceling_array: Dictionary, canceled_array: Dictionary) -> void:
	canceled_array["w_result"].sort()
	canceled_array["w_result"].reverse()
	for idx:int in canceling_array["w_result"]:
		if !canceled_array["w_result"]:
			break
		canceled_array["w_result"].pop_front()
	
	var new_damage: int = sum_array(canceled_array["w_result"])
	canceled_array["damage_dealt"] = new_damage
	
	#print_debug("Player deals " + str(canceled_array) )
	#print_debug("Player deals " + str(canceled_array) )

func roll_dice_from_action(input_action: Action) -> Array[int]:
	var win_numbers: Array[int] = input_action.win_conditions
	var output_dice_array: Array[int]
	for idx in input_action.min_stamina_dice_cost: 
		for threshold: int in win_numbers:
			var dice_result = randi_range(1,player_stamina_dice_size) #rolls the dice
			#print_debug("The die rolled a " + str(dice_result))
			if dice_result == threshold: #if the dice meets a threshold number add it to the output array
				output_dice_array.append(dice_result)
				#print_debug("The threshold nubers are " + str(win_numbers))
				break
	
	#print_debug("the final dice array is " + str(output_dice_array) )
	return output_dice_array


func sum_array(input_array: Array[int]) -> int:
	var array_sum: int 
	for idx: int in input_array:
		array_sum += idx
	
	return array_sum
