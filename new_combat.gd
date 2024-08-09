extends Node


@export var Player: CharacterSheet
@export var Mob: CharacterSheet

@export var player_weapon: Weapon
@export var mob_weapon: Weapon

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


@onready var action_roller_menu = $ActionRollerMenu as ActionRollerMenu
@onready var armor_roller_menu = $ArmorRollerMenu as ArmorRollerMenu




var player_stamina_dice_size: int = 6
var player_stamina_dice_pool: Array[int]
var player_stamina: int = 20

var player_outcome_roll: Dictionary
var mob_outcome_roll: Dictionary

func _ready() -> void:
	randomize()
	populate_dropdown_with_actions() 
	option_button.select(-1)
	#print_debug( player_weapon.apply_armor(2,[2,3,6]) )
	action_roller_menu.generate_action_buttons(PlayerActions)
	
	action_roller_menu.connect("player_action_rolled",Callable(self,"load_player_roll_outcome"))
	action_roller_menu.connect("player_rolled_button",Callable(armor_roller_menu,"_on_roll_mob_dice_pressed")) #rolls enemey and player dice
	
	armor_roller_menu.connect("mob_action_rolled",Callable(self,"load_mob_roll_outcome"))


func load_player_roll_outcome(player_roll_dictionary: Dictionary) -> void:
	player_outcome_roll = player_roll_dictionary
	#print_debug(player_outcome_roll)
	

func load_mob_roll_outcome(mob_roll_dictionary: Dictionary) -> void:
	mob_outcome_roll = mob_roll_dictionary
	compare_actions(player_outcome_roll,mob_outcome_roll)
	#print_debug(mob_outcome_roll)



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
		#print_debug(player_weapon.roll_dice_check_single_w(6,6))
		#print_debug(player_weapon.check_crit([6,6,2]))
		print_debug("select an attack for the player")
		return
	
	var current_player_attack: Action = option_button.get_item_metadata(option_button.get_selected_id())
	#var player_output_attack_roll: Array[int] = roll_dice_from_action(current_player_attack)
	#print_debug(roll_dice_from_action(current_player_attack))
	
	var current_mob_attack: Action = select_an_attack(MobActions)
	#compare_actions(current_player_attack, current_mob_attack)
	#var mob_output_attack_roll: Array[int] = roll_dice_from_action(current_mob_attack)
	label.set_text("Enemy uses " + str(current_mob_attack.action_name) )
	


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
