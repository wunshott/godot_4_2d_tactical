extends Node


@export var Player: CharacterSheet
@export var Mob: CharacterSheet

@export var PlayerActions: Array[Action]
@export var PlayerArmor: Array[int]

@export var MobActions: Array[Action]
@export var MobArmor: Array[int]
#assuming a Xd6 dice roll and combat to end in 6 turns
#how much Hp should characters have
#how much stamina should they have
#how much stamina should each attack cost
@onready var option_button = $OptionButton as OptionButton
@onready var button = $Button as Button
@onready var label = $Label as Label


var player_stamina_dice_size: int = 6
var player_stamina_dice_pool: Array[int]
var player_stamina: int = 20



func _ready() -> void:
	randomize()
	populate_dropdown_with_actions() 
	option_button.select(-1)
	
	


func select_an_attack(input_action_array:Array[Action]) -> Action:
	var action_selectd: Action = input_action_array[randi_range(0,input_action_array.size()-1)] #select a random action
	return action_selectd
	
func create_action_dice_array(input_dice_size: int, action_stamina_cost: int) -> Array:
	var output_stamina_array: Array[int]
	
	output_stamina_array.resize(action_stamina_cost)
	output_stamina_array.fill(input_dice_size)
	
	return output_stamina_array

func populate_dropdown_with_actions() -> void:
	for action_to_add:Action in PlayerActions:
		option_button.add_item(action_to_add.action_name)
		option_button.set_item_metadata(-1,action_to_add)
	return
	


func _on_option_button_item_selected(index):
	return
	print_debug(option_button.get_item_metadata(index).min_stamina_dice_cost)


func _on_button_pressed():
	#print_debug(option_button.get_selected_id())
	if option_button.get_selected_id() == -1:
		print_debug("select an attack for the player")
		return
	
	var current_player_attack: Action = option_button.get_item_metadata(option_button.get_selected_id())
	#var player_output_attack_roll: Array[int] = roll_dice_from_action(current_player_attack)
	#print_debug(roll_dice_from_action(current_player_attack))
	
	var current_mob_attack: Action = select_an_attack(MobActions)
	compare_actions(current_player_attack, current_mob_attack)
	#var mob_output_attack_roll: Array[int] = roll_dice_from_action(current_mob_attack)
	label.set_text("Enemy uses " + str(current_mob_attack.action_name) )


func compare_actions(action1: Action, action2: Action, action3: Action = null) -> void:
	var player_output_action_roll: Array[int] = roll_dice_from_action(action1)
	var mob_output_action_roll: Array[int] = roll_dice_from_action(action2)
	#all ws from roll
	
	##Grapples are attack/defense/fakouts by of a grapple class. allows you to check both types
	if action1 is Grapple and action2 is Grapple:
		# muscle out stalemate
		return
		
	elif action2 is Grapple:
		#check is action 1 is A,D,F
		return
	
	elif action1 is Grapple:
		return
	
	else: #neither are grapples
		#check if actions are A,D,F
		if action1.attack_type == Action.ATTACK_TYPE.Attack:
			if action2.attack_type == Action.ATTACK_TYPE.Defend: # attack vs defense
				#subtract from attacker dice array. how do you pick which dice to delete? #TODO start here
				#if armor blocks specific dice values, then the player would remove wins that aren't the armor value
				#unless Ws in defend rolls do something else? add to dodge?
				#How to code this:
					#check armor block values:
					# while defend Ws > 0:
						# Sort attacker array from highest to lowest
						# check each value of the array
						# if that value != a value on the armor, pop it out
							#reduce Ws by 1
						# repeat
				while mob_output_action_roll.size() > 0:
					player_output_action_roll.sort()
					for idx: int in player_output_action_roll:
						for idx: int in 
							
						
					return
			elif action2.attack_type == Action.ATTACK_TYPE.Attack: # attack vs attack
				#compute damage after pass through armor and dodge
				return
			elif action2.attack_type == Action.ATTACK_TYPE.Fakeout: # attack vs fakeout
				return
			return
		
		
		if action1.attack_type == Action.ATTACK_TYPE.Defend:
			if action2.attack_type == Action.ATTACK_TYPE.Defend: # defense vs defense
				return
			elif action2.attack_type == Action.ATTACK_TYPE.Fakeout: # defense vs fakeout
				return
		
		
		if action1.attack_type == Action.ATTACK_TYPE.Fakeout:
			if action2.attack_type == Action.ATTACK_TYPE.Fakeout: # fakeout vs fakeout 
				return
		
		
		
		
	return

	
func roll_dice_from_action(input_action: Action) -> Array[int]: #assume all stamina dice are 1 size. d6
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


