extends Node

class_name TestBattle

@export var player_class: Class
@export var enemy_class: Class

#@export var player_attack_dice_array: Array[int]
#@export var player_defense_dice_array: Array[int]

@export var player_dodge_threshold: int

@export var player_weapon_graze_threshold: int
#
#@export var target_attack_dice_array: Array[int]
#@export var target_defense_dice_array: Array[int]

@export var target_dodge_threshold: int

@export var target_weapon_graze_threshold: int

@onready var play_hp_label: Label = $HBoxContainer/PlayHpLabel
@onready var player_hp: ProgressBar = $HBoxContainer/PlayerHp

@onready var enemy_hp_label: Label = $HBoxContainer2/EnemyHpLabel
@onready var enemy_hp: ProgressBar = $HBoxContainer2/EnemyHp
@onready var player_buttons = $Buttons/PlayerButtons
@onready var enemy_buttons = $Buttons/EnemyButtons
@onready var fight: Button = $Buttons/Fight
@onready var cancel: Button  = $Buttons/Cancel

@onready var button_signals = $ButtonSignals



var number_of_turns: int
# Called when the node enters the scene tree for the first time.

#TODO
#add an armor threshold
#dice attack dice only get thru if the player's dice roll above armor threshold
#only dice above this threshold get thru

#target has a dodge threshold
#target rolls their dodge, each one thta passes the threshold is a W. each W subtracts from attack wins

var test_array = [5, 6, 72, 1]
# can add perks to increase the graze floor
# can add perks to tighten the dodge and graze range

#TODO how to affect weapon hit die when attacking a limb? cap of max limb hit dice
#choose defensives or offensive spread. do they have 1d2 or two d1s. the d1s are more aggressive and the 1d2 is more defensive
#TODO split how the limb dice are applied on attack
#TODO split how each target focuses the limbs
#TODO end the battle once DT= HP of a fighter

#TODO data to collect
#who won, bar graph. y = number of times 
#enemy arm HP at the end
#player arm HP at the end
#highest damage dealt that battle and by who
#longest missing streaks by a combatant during the battle
#number of turns 
@export var number_of_battles: int
var rogue_victories: int
var warrior_victories: int
var ties: int
var PlayerTargetLimb: Array
var EnemeyTargetLimb: Array

var original_player_dice: Dictionary
var original_enemy_dice: Dictionary

func _process(delta):
	return
	if player_class.right_arm_dice.is_empty() or enemy_class.right_arm_dice.is_empty():
		return
		
	else:
		number_of_turns += 1
		#print("Turn: " + str(number_of_turns))
		combat_dice_trade_hp_pool_with_classes_full_limb()
		#print("-------------------")
		#print("-------------------")

func select_a_random_target(node: Node) -> void:
	var random_limb_chose:int = randi_range(0,node.get_child_count()-1)
	node.get_child(random_limb_chose).emit_signal("pressed")



func _ready():
	randomize()
	player_class.connect("HP_changed",Callable(player_hp,"set_value"))
	player_class.connect("HP_changed",Callable(play_hp_label,"convert_int_to_string_send_to_label"))
	enemy_class.connect("HP_changed",Callable(enemy_hp,"set_value"))
	enemy_class.connect("HP_changed",Callable(enemy_hp_label,"convert_int_to_string_send_to_label"))
	
	player_class.initialize_limb_hp()
	enemy_class.initialize_limb_hp()
	
	original_player_dice = player_class.limb_dictionary.duplicate(true)
	original_enemy_dice = enemy_class.limb_dictionary.duplicate(true)
	
	fill_out_limbs()
	
	#print(roll_limb_dice(decide_roll_split("rogue")["attack"]))
	#print(roll_limb_dice(decide_roll_split("rogue")["defense"]))
	#print(enemy_class.left_leg_dice)
	#enemy_class.focus_max_element(enemy_class.left_leg_dice,10)
	#print(enemy_class.left_leg_dice)
	#print(enemy_class.head_dice)
	#enemy_class.focus_max_element(enemy_class.head_dice,2)
	#print(enemy_class.head_dice)
	#TODO redo automated battle logic, do you even need it?
	#combat_dice_trade_hp_pool_with_classes_full_limb()
	for i in range(number_of_battles):
		
		print("Before Battle: ")
		display_dice_array("Player",player_class.limb_dictionary)
		print(player_class.get_HP())
		print("----------------------------")
		display_dice_array("Enemy",enemy_class.limb_dictionary)
		print(enemy_class.get_HP())
			
		while player_class.get_HP() > 0 and enemy_class.get_HP()  > 0:
			
			var enemy_key_to_remove := []
			for key in enemy_class.limb_dictionary.keys():
				if enemy_class.limb_dictionary[key].is_empty():
					enemy_key_to_remove.append(key)
			for key in enemy_key_to_remove:
				enemy_class.limb_dictionary.erase(key)
			
			var player_key_to_remove := []
			for key in player_class.limb_dictionary.keys():
				if player_class.limb_dictionary[key].is_empty():
					player_key_to_remove.append(key)
			for key in player_key_to_remove:
				player_class.limb_dictionary.erase(key)
			
			var player_selected_target_index: int = randi_range(0, enemy_class.limb_dictionary.values().size()-1)
			var enemy_selected_target_index: int = randi_range(0, player_class.limb_dictionary.values().size()-1)
			
			
			
			if player_selected_target_index < 0 or enemy_selected_target_index < 0:
				print(player_class.get_HP())
				print(enemy_class.get_HP())
				print("stop")
			
			var player_selected_target: String = enemy_class.limb_dictionary.find_key( enemy_class.limb_dictionary.values()[player_selected_target_index] )
			var enemy_selected_target: String = player_class.limb_dictionary.find_key( player_class.limb_dictionary.values()[enemy_selected_target_index] )
			#print("stop")
			combat_dice_trade_hp_pool_with_classes_full_limb_button(player_selected_target, enemy_class.limb_dictionary, 
			enemy_selected_target,player_class.limb_dictionary)
			
					
			
			number_of_turns += 1
			#print("Turn: " + str(number_of_turns))
			#print("-------------------")
			#print("-------------------")
			var player_hp: int = player_class.get_HP()
			var enemy_hp: int = enemy_class.get_HP()
			#print("stop")
		
		print("After Battle: ")
		display_dice_array("Player",player_class.limb_dictionary)
		print(player_class.get_HP())
		print("----------------------------")
		display_dice_array("Enemy",enemy_class.limb_dictionary)
		print(enemy_class.get_HP())
		#print("stop")
		
		if player_class.get_HP() == 0 and enemy_class.get_HP() == 0:
			ties += 1
		
		elif player_class.get_HP() == 0: #warrior wins
			warrior_victories += 1
		
		elif enemy_class.get_HP() == 0: #rogue wins
			rogue_victories += 1 
		
		# replenish the limb arrays
		player_class.limb_dictionary = original_player_dice.duplicate(true)
		enemy_class.limb_dictionary = original_enemy_dice.duplicate(true)
		
		#print("stop")
		#player_class.initialize_limb_hp()
		#enemy_class.initialize_limb_hp()
		fill_out_limbs() #TODO hp not reseting properly after fights. 
		#print("stop")

		#reset_limb(player_class.limb_dictionary, player_class)
		#reset_limb(enemy_class.limb_dictionary , enemy_class)
		#print("stop")
		number_of_turns = 0 # reset turns
	
	print("rogue victories = " + str(rogue_victories) )
	print("warrior victories = " + str(warrior_victories) )
	print("Ties = " + str(ties) )

func reset_limb(original_limb_hp: Dictionary, combatant: Class) -> void:
	combatant.head_dice =  original_limb_hp["head"].duplicate(true)
	combatant.torso_dice =  original_limb_hp["torso"].duplicate(true)
	combatant.right_arm_dice = original_limb_hp["right_arm"].duplicate(true)
	combatant.left_arm_dice = original_limb_hp["left_arm"].duplicate(true)
	combatant.right_leg_dice = original_limb_hp["right_leg"].duplicate(true)
	combatant.left_leg_dice = original_limb_hp["left_leg"].duplicate(true)

func roll_limb_dice(input_array: Array) -> Array:
	var output_array: Array
	for element in input_array:
		var dice_outomce: int = randi_range(1,element)
		output_array.append(dice_outomce)
	return output_array

func add_arrays(input_array_1: Array, input_array_2: Array, input_array_3: Array = []) -> Array:
	var output_array: Array
	output_array.append_array(input_array_1)
	output_array.append_array(input_array_2)
	output_array.append_array(input_array_3)
	return output_array

func display_dice_array(Combatant: String, CombatantArray: Dictionary) -> void:
	for limb in CombatantArray.keys():
		print(str(Combatant) + " " + str(limb) + " dice: " + str(CombatantArray[limb]) )
	

func decide_roll_split(class_title: String) -> Dictionary: #figure out which limb the opponnet is attacking, append the defense array with armor
	var attack_defense_dict: Dictionary
	
	
	if class_title == "rogue":
		var temp_class_arm_dice: Array[int]
		if player_class.limb_dictionary.has("right_arm"):
			temp_class_arm_dice.append_array(player_class.limb_dictionary["right_arm"])
		if player_class.limb_dictionary.has("left_arm"):
			temp_class_arm_dice.append_array(player_class.limb_dictionary["left_arm"])
			#var temp_class_arm_dice: Array = add_arrays(player_class.limb_dictionary["right_arm"].duplicate(true),player_class.limb_dictionary["left_arm"].duplicate(true))
		var temp_weapon_array: Array = add_arrays(player_class.left_weapon, player_class.right_weapon)
		var temp_attack_array: Array[int]
		var temp_defense_array: Array[int]
		temp_attack_array.append_array(temp_weapon_array)
		for dice in temp_class_arm_dice:
			if dice == 2:
				temp_defense_array.append(dice) 
			else:
				temp_attack_array.append(dice)
		# create a temp array that combines the arms
		# puts all 2s into defense. puts all 1s and greater than 2s in attack
		# dump the rest into attack and the weapons
		attack_defense_dict["attack"] = temp_attack_array
		attack_defense_dict["defense"] = temp_defense_array
		#print("stop")
		
		return attack_defense_dict
	
	else:# warrior class
		#var temp_class_arm_dice: Array = add_arrays(enemy_class.limb_dictionary["right_arm"].duplicate(true),enemy_class.limb_dictionary["left_arm"].duplicate(true))
		var temp_class_arm_dice: Array[int] 
		if enemy_class.limb_dictionary.has("right_arm"):
			temp_class_arm_dice.append_array(enemy_class.limb_dictionary["right_arm"])
		if enemy_class.limb_dictionary.has("left_arm"):
			temp_class_arm_dice.append_array(enemy_class.limb_dictionary["left_arm"])
			
		var temp_attack_array: Array[int] 
		var temp_defense_array: Array[int] 
		var temp_weapon_array: Array[int]  = enemy_class.right_weapon
		temp_attack_array.append_array(temp_weapon_array)
		temp_defense_array.append_array(enemy_class.left_weapon)
		
		if temp_class_arm_dice.size() > 1: #if the right arm dice is greater than 1, take the max to attack and put the rest in defense
			var max_index = get_index_of_highest_die_in_array(temp_class_arm_dice)
			temp_attack_array.append(temp_class_arm_dice)
			temp_class_arm_dice.remove_at(max_index)
			temp_defense_array.append_array(temp_class_arm_dice)
			
		else: #dump the last die into attack
			temp_attack_array.append_array(temp_class_arm_dice)
		
		attack_defense_dict["attack"] = temp_attack_array
		attack_defense_dict["defense"] = temp_defense_array
		
		return attack_defense_dict

func get_index_of_highest_die_in_array(input_array: Array[int] ) -> int:
	var max_value: int = input_array[0]
	var max_index: int = 0
	for i in range(input_array.size()):
		if input_array[i] > max_value:
			max_value = input_array[i]
			max_index = i
	return max_index

func combat_dice_trade_hp_pool_with_classes_full_limb_button(PlayerTargetLimb: String,EnemyLimbDict: Dictionary, EnemyTargetLimb: String,
PlayerLimbDict: Dictionary) -> void:
	var player_attack_dice_array_random: Array[int]
	var player_defense_dice_array_random: Array[int]
	var target_attack_dice_array_random: Array[int]
	var target_defense_dice_array_random: Array[int]
	
	# pass a dictionary instead of array to check the limb type to add the armor
	target_defense_dice_array_random.append_array(roll_limb_dice(enemy_class.equipped_armor_dictionary[PlayerTargetLimb]))
	player_defense_dice_array_random.append_array(roll_limb_dice(player_class.equipped_armor_dictionary[EnemyTargetLimb]))
	#print("stop")
	
	player_attack_dice_array_random.append_array(roll_limb_dice(decide_roll_split("rogue")["attack"]))
	player_defense_dice_array_random.append_array(roll_limb_dice(decide_roll_split("rogue")["defense"]))
	#print("stop")
	
	
	target_attack_dice_array_random.append_array(roll_limb_dice(decide_roll_split("warrior")["attack"]))
	target_defense_dice_array_random.append_array(roll_limb_dice(decide_roll_split("warrior")["defense"]))
	
	
	#print("original arrays: ")
	#display_dice_array("Player",PlayerLimbDict)
	#print("----------------------------")
	#display_dice_array("Enemy",EnemyLimbDict)
	
	#print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	#print("target defender dice array: " + str(target_defense_dice_array_random) + " target attacker dice array: " + str(target_attack_dice_array_random))
	
	#print("-----------------------------")
	defender_chooses(player_attack_dice_array_random, player_defense_dice_array_random, target_attack_dice_array_random, target_defense_dice_array_random)
	#print("-----------------------------")
	
	#print("after combat results: ")
	#print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
#
	#print("target defender dice array: " + str(target_defense_dice_array_random) + " target attacker dice array: " + str(target_attack_dice_array_random))
	#
	
	
	#print("----------------")
	#print("attack damage dealt from player to target: ")
	var player_attack_sum: int = sum_attack_array(player_attack_dice_array_random)
	#print("sum of player attack dice = " + str(player_attack_sum) )
	#print("the player's weapon's graze modifier is = " + str(player_weapon_graze_threshold) )
	#print("target dodge threshold is = " + str(target_dodge_threshold))

	
	if player_attack_sum < target_dodge_threshold:
		var target_adjusted_dodge_threshold: int = target_dodge_threshold - player_weapon_graze_threshold
		var player_damage_dealt: int = player_attack_sum - ( target_adjusted_dodge_threshold ) #TODO pick the lowest of threshold when compared to the weapon graze
		#print("target's modified dodge threshold is = " + str(target_adjusted_dodge_threshold) )
		#print("the player deals this much damage target = " + str(player_damage_dealt ) )
		
		enemy_class.focus_max_element(EnemyLimbDict[PlayerTargetLimb],clamp(player_damage_dealt,0,999) )
		enemy_class.set_HP()
		
	else:
		var player_damage_dealt: int = player_attack_sum - target_dodge_threshold
		#print("the player deals this much damage target = " + str(player_damage_dealt ) )
		enemy_class.focus_max_element(EnemyLimbDict[PlayerTargetLimb],clamp(player_damage_dealt,0,999) )
		enemy_class.set_HP()
	

	#print("attack damage dealt from target to player: ")
	var target_attack_sum: int = sum_attack_array(target_attack_dice_array_random)
	#print("sum of target attack dice = " + str(target_attack_sum) )
	#print("the target's weapon's graze modifier is = " + str(target_weapon_graze_threshold) )
	#print("player dodge threshold is = " + str(player_dodge_threshold))
	
	if target_attack_sum < player_dodge_threshold: #TODO make <=? turn into a function
		var player_adjusted_dodge_threshold:int = player_dodge_threshold - target_weapon_graze_threshold
		var target_damage_dealt: int = target_attack_sum - (player_adjusted_dodge_threshold)
		#print("player's modified dodge threshold is = " + str(player_adjusted_dodge_threshold) )
		#print("the target deals this much damage to player = " + str(target_damage_dealt) )
		player_class.focus_max_element(PlayerLimbDict[EnemyTargetLimb], clamp(target_damage_dealt,0,999) )
		player_class.set_HP()

		
	else:
		var target_damage_dealt: int = target_attack_sum - player_dodge_threshold
		#print("the target deals this much damage to player = " + str(target_damage_dealt) )
		player_class.focus_max_element(PlayerLimbDict[EnemyTargetLimb],clamp(target_damage_dealt,0,999))
		player_class.set_HP()
	
	#print("after combat arrays: ")
	#display_dice_array("Player",PlayerLimbDict)
	#print("----------------------------")
	#display_dice_array("Enemy",EnemyLimbDict)
	#print("----------------")


func fill_out_limbs() -> void:
	player_class.set_max_HP()
	player_hp.set_max(player_class.get_max_HP())
	
	enemy_class.set_max_HP()
	enemy_hp.set_max(enemy_class.get_max_HP())
	
	
	player_class.set_HP()
	player_hp.set_value(player_class.get_HP())
	play_hp_label.set_text(str(player_class.get_HP()))
	
	
	
	enemy_class.set_HP()
	enemy_hp.set_value(enemy_class.get_HP())
	enemy_hp_label.set_text(str(enemy_class.get_HP()))
	
func combat_dice_trade_hp_pool_with_classes_full_limb() -> void:
	
	var player_attack_dice_array_random: Array[int]
	player_attack_dice_array_random.append_array(roll_limb_dice(decide_roll_split("rogue")["attack"]))
	var player_defense_dice_array_random: Array[int] 
	player_defense_dice_array_random.append_array(roll_limb_dice(decide_roll_split("rogue")["defense"]))
	
	
	var target_attack_dice_array_random: Array[int]
	target_attack_dice_array_random.append_array(roll_limb_dice(decide_roll_split("warrior")["attack"]))
	var target_defense_dice_array_random: Array[int]
	target_defense_dice_array_random.append_array(roll_limb_dice(decide_roll_split("warrior")["defense"]))
	
	
	
	print("original arrays: ")
	print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	print("target defender dice array: " + str(target_defense_dice_array_random) + " target attacker dice array: " + str(target_attack_dice_array_random))
	
	defender_chooses(player_attack_dice_array_random, player_defense_dice_array_random, target_attack_dice_array_random, target_defense_dice_array_random)
	
	print("after combat results: ")
	print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	print("target defender dice array: " + str(target_defense_dice_array_random) + " target attacker dice array: " + str(target_attack_dice_array_random))
	
	print("----------------")
	print("attack damage dealt from player to target: ")
	var player_attack_sum: int = sum_attack_array(player_attack_dice_array_random)
	print("sum of player attack dice = " + str(player_attack_sum) )
	print("the player's weapon's graze modifier is = " + str(player_weapon_graze_threshold) )
	print("target dodge threshold is = " + str(target_dodge_threshold))
	
	return
	
	
	if player_attack_sum < target_dodge_threshold:
		var target_adjusted_dodge_threshold: int = target_dodge_threshold - player_weapon_graze_threshold
		var player_damage_dealt: int = player_attack_sum - ( target_adjusted_dodge_threshold ) #TODO pick the lowest of threshold when compared to the weapon graze
		print("target's modified dodge threshold is = " + str(target_adjusted_dodge_threshold) )
		print("the player deals this much damage target = " + str(player_damage_dealt ) )
		enemy_class.focus_max_element(enemy_class.right_arm_dice,clamp(player_damage_dealt,0,999) )
		print("the target's right arm's current health: " + str(enemy_class.right_arm_dice) )
		
	else:
		var player_damage_dealt: int = player_attack_sum - target_dodge_threshold
		print("the player deals this much damage target = " + str(player_damage_dealt ) )
		enemy_class.focus_max_element(enemy_class.right_arm_dice,clamp(player_damage_dealt,0,999) )
		print("the target's right arm's current health: " + str(enemy_class.right_arm_dice) )
	

	#print("----------------")
	#print("attack damage dealt from target to player: ")
	var target_attack_sum: int = sum_attack_array(target_attack_dice_array_random)
	#print("sum of target attack dice = " + str(target_attack_sum) )
	#print("the target's weapon's graze modifier is = " + str(target_weapon_graze_threshold) )
	#print("player dodge threshold is = " + str(player_dodge_threshold))
	
	if target_attack_sum < player_dodge_threshold: #TODO make <=? turn into a function
		var player_adjusted_dodge_threshold:int = player_dodge_threshold - target_weapon_graze_threshold
		var target_damage_dealt: int = target_attack_sum - (player_adjusted_dodge_threshold)
		#print("player's modified dodge threshold is = " + str(player_adjusted_dodge_threshold) )
		#print("the target deals this much damage to player = " + str(target_damage_dealt) )
		player_class.focus_max_element(player_class.right_arm_dice, clamp(target_damage_dealt,0,999) )
		#print("the player's right arm's current health: " + str(player_class.right_arm_dice) )
		
	else:
		var target_damage_dealt: int = target_attack_sum - player_dodge_threshold
		#print("the target deals this much damage to player = " + str(target_damage_dealt) )
		player_class.focus_max_element(player_class.right_arm_dice,clamp(target_damage_dealt,0,999))
		#print("the player's right arm's current health: " + str(player_class.right_arm_dice) )


func combat_dice_trade_hp_pool_with_classes() -> void:
	var player_attack_dice_array_random: Array[int]
	player_attack_dice_array_random.append_array(add_arrays(roll_limb_dice(player_class.right_arm_dice), roll_limb_dice(player_class.right_weapon) ))
	var player_defense_dice_array_random: Array[int] 
	player_defense_dice_array_random.append_array(add_arrays(roll_limb_dice(player_class.left_arm_dice), roll_limb_dice(player_class.left_weapon) ))
	
	var target_attack_dice_array_random: Array[int]
	target_attack_dice_array_random.append_array(add_arrays(roll_limb_dice(enemy_class.right_arm_dice), roll_limb_dice(enemy_class.right_weapon) ))
	var target_defense_dice_array_random: Array[int]
	target_defense_dice_array_random.append_array(add_arrays(roll_limb_dice(enemy_class.left_arm_dice), roll_limb_dice(enemy_class.left_weapon) ))
	
	
	#print("original arrays: ")
	#print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	#print("target defender dice array: " + str(target_defense_dice_array_random) + " target attacker dice array: " + str(target_attack_dice_array_random))
	
	defender_chooses(player_attack_dice_array_random, player_defense_dice_array_random, target_attack_dice_array_random, target_defense_dice_array_random)
	
	#print("after combat results: ")
	#print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	#print("target defender dice array: " + str(target_defense_dice_array_random) + " target attacker dice array: " + str(target_attack_dice_array_random))
	#
	#print("----------------")
	#print("attack damage dealt from player to target: ")
	var player_attack_sum: int = sum_attack_array(player_attack_dice_array_random)
	#print("sum of player attack dice = " + str(player_attack_sum) )
	#print("the player's weapon's graze modifier is = " + str(player_weapon_graze_threshold) )
	#print("target dodge threshold is = " + str(target_dodge_threshold))
	
	if player_attack_sum < target_dodge_threshold:
		var target_adjusted_dodge_threshold: int = target_dodge_threshold - player_weapon_graze_threshold
		var player_damage_dealt: int = player_attack_sum - ( target_adjusted_dodge_threshold ) #TODO pick the lowest of threshold when compared to the weapon graze
		#print("target's modified dodge threshold is = " + str(target_adjusted_dodge_threshold) )
		#print("the player deals this much damage target = " + str(player_damage_dealt ) )
		enemy_class.focus_max_element(enemy_class.right_arm_dice,clamp(player_damage_dealt,0,999) )
		#print("the target's right arm's current health: " + str(enemy_class.right_arm_dice) )
		
	else:
		var player_damage_dealt: int = player_attack_sum - target_dodge_threshold
		#print("the player deals this much damage target = " + str(player_damage_dealt ) )
		enemy_class.focus_max_element(enemy_class.right_arm_dice,clamp(player_damage_dealt,0,999) )
		#print("the target's right arm's current health: " + str(enemy_class.right_arm_dice) )
	
	#print("----------------")
	#print("attack damage dealt from target to player: ")
	var target_attack_sum: int = sum_attack_array(target_attack_dice_array_random)
	#print("sum of target attack dice = " + str(target_attack_sum) )
	#print("the target's weapon's graze modifier is = " + str(target_weapon_graze_threshold) )
	#print("player dodge threshold is = " + str(player_dodge_threshold))
	
	if target_attack_sum < player_dodge_threshold: #TODO make <=? turn into a function
		var player_adjusted_dodge_threshold:int = player_dodge_threshold - target_weapon_graze_threshold
		var target_damage_dealt: int = target_attack_sum - (player_adjusted_dodge_threshold)
		#print("player's modified dodge threshold is = " + str(player_adjusted_dodge_threshold) )
		#print("the target deals this much damage to player = " + str(target_damage_dealt) )
		player_class.focus_max_element(player_class.right_arm_dice, clamp(target_damage_dealt,0,999) )
		#print("the player's right arm's current health: " + str(player_class.right_arm_dice) )
		
	else:
		var target_damage_dealt: int = target_attack_sum - player_dodge_threshold
		#print("the target deals this much damage to player = " + str(target_damage_dealt) )
		player_class.focus_max_element(player_class.right_arm_dice,clamp(target_damage_dealt,0,999))
		#print("the player's right arm's current health: " + str(player_class.right_arm_dice) )


func combat_dice_trade_hp_pool() -> void:
	var player_attack_dice_array_size: int = randi_range(2,5)
	var player_defense_dice_array_size:int = randi_range(1,3)
	var player_attack_dice_array_random: Array[int]
	var player_defense_dice_array_random: Array[int]
	
	var target_attack_dice_array_size: int = randi_range(2,5)
	var target_defense_dice_array_size:int = randi_range(2,5)
	var target_attack_dice_array_random: Array[int]
	var target_defense_dice_array_random: Array[int]
	
	for attack_dice in range(player_attack_dice_array_size):
		player_attack_dice_array_random.append(randi_range(1,6)) #create a class for these
		
	for defense_dice in range(player_defense_dice_array_size):
		player_defense_dice_array_random.append(randi_range(1,6))
		
	for attack_dice in range(target_attack_dice_array_size):
		target_attack_dice_array_random.append(randi_range(1,6))
		
	for defense_dice in range(target_defense_dice_array_size):
		target_defense_dice_array_random.append(randi_range(1,6))
	
	print("original arrays: ")
	print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	print("target defender dice array: " + str(target_defense_dice_array_random) + "target attacker dice array: " + str(target_attack_dice_array_random))
	
	defender_chooses(player_attack_dice_array_random, player_defense_dice_array_random, target_attack_dice_array_random, target_defense_dice_array_random)
	
	print("after combat results: ")
	print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	print("target defender dice array: " + str(target_defense_dice_array_random) + "target attacker dice array: " + str(target_attack_dice_array_random))
	
	print("----------------")
	print("attack damage dealt from player to target: ")
	var player_attack_sum: int = sum_attack_array(player_attack_dice_array_random)
	print("sum of player attack dice = " + str(player_attack_sum) )
	print("the player's weapon's graze modifier is = " + str(player_weapon_graze_threshold) )
	print("target dodge threshold is = " + str(target_dodge_threshold))
	
	if player_attack_sum < target_dodge_threshold:
		var target_adjusted_dodge_threshold: int = target_dodge_threshold - player_weapon_graze_threshold
		var player_damage_dealt: int = player_attack_sum - ( target_adjusted_dodge_threshold )
		print("target's modified dodge threshold is = " + str(target_adjusted_dodge_threshold) )
		print("the player deals this much damage target = " + str(player_damage_dealt ) )
	else:
		var player_damage_dealt: int = player_attack_sum - target_dodge_threshold
		print("the player deals this much damage target = " + str(player_damage_dealt ) )
	
	print("----------------")
	print("attack damage dealt from target to player: ")
	var target_attack_sum: int = sum_attack_array(target_attack_dice_array_random)
	print("sum of player attack dice = " + str(target_attack_sum) )
	print("the target's weapon's graze modifier is = " + str(target_weapon_graze_threshold) )
	print("player dodge threshold is = " + str(player_dodge_threshold))
	
	if target_attack_sum < player_dodge_threshold:
		var player_adjusted_dodge_threshold:int = player_dodge_threshold - target_weapon_graze_threshold
		var target_damage_dealt: int = target_attack_sum - (player_adjusted_dodge_threshold)
		print("player's modified dodge threshold is = " + str(player_adjusted_dodge_threshold) )
		print("the target deals this much damage to player = " + str(target_damage_dealt) )
	else:
		var target_damage_dealt: int = target_attack_sum - player_dodge_threshold
		print("the target deals this much damage to player = " + str(target_damage_dealt) )
	

func sum_attack_array(attack_dice: Array[int]) -> int:
	var attack_damage: int
	for dice in attack_dice:
		attack_damage += dice
	return attack_damage


func colin_outcome(attack_dice_array: Array[int], defender_dice_array: Array[int]):
	var defender_dice_array_copy: Array[int]
	var attacker_dice_array_copy: Array[int]
	defender_dice_array_copy.append_array(defender_dice_array)
	attacker_dice_array_copy.append_array(attack_dice_array)
	defender_dice_array_copy.sort()
	#defender_dice_array_copy.reverse()
	defender_dice_array.sort()
	#defender_dice_array.reverse()
	
	attack_dice_array.sort()
	attack_dice_array.reverse()
	
	for defense_dice in defender_dice_array_copy:
		var index_of_element_to_remove: int = 0
		var index_attack: int = 0
		var pop_attack_die: bool = false
		for attack_dice in attack_dice_array:
			if defense_dice >= attack_dice:
				index_of_element_to_remove = index_attack
				pop_attack_die = true
				break
			index_attack += 1
		if pop_attack_die == true:
			attack_dice_array.pop_at(index_of_element_to_remove)
			defender_dice_array.erase(defense_dice)
	
	
func defender_chooses(player_attack_dice_array: Array[int], player_defense_dice_array: Array[int], 
target_attack_dice_array: Array[int], target_defense_dice_array: Array[int]) -> void:
	colin_outcome(target_attack_dice_array,player_defense_dice_array)
	colin_outcome(player_attack_dice_array,target_defense_dice_array)
	
	

func colin_outcome_input() -> void:
	var attack_dice_array_size: int = randi_range(1,5)
	var defender_dice_array_size:int = randi_range(1,5)
	var attack_dice_array_random: Array[int]
	var defender_dice_array_random: Array[int]
	
	for attack_dice in range(attack_dice_array_size):
		attack_dice_array_random.append(randi_range(1,6))
		
	for defense_dice in range(defender_dice_array_size):
		defender_dice_array_random.append(randi_range(1,6))
		
		
	#print(attack_dice_array)
	#attack_dice_array.sort()
	#attack_dice_array.reverse()
	#print(attack_dice_array)
	#colin_outcome(attack_dice_array, defender_dice_array)
	attack_dice_array_random.sort()
	attack_dice_array_random.reverse()
	defender_dice_array_random.sort()
	defender_dice_array_random.reverse()

	print("original attacker dice array = " + str(attack_dice_array_random) )
	print("original defender dice array = " + str(defender_dice_array_random) )

func sum_attack_array_combat() -> void:
	
	var player_attack_dice_array_size: int = randi_range(2,5)
	var player_defense_dice_array_size:int = randi_range(1,3)
	var player_attack_dice_array_random: Array[int]
	var player_defense_dice_array_random: Array[int]
	
	var target_attack_dice_array_size: int = randi_range(2,5)
	var target_defense_dice_array_size:int = randi_range(2,5)
	var target_attack_dice_array_random: Array[int]
	var target_defense_dice_array_random: Array[int]
	
	for attack_dice in range(player_attack_dice_array_size):
		player_attack_dice_array_random.append(randi_range(1,6))
		
	for defense_dice in range(player_defense_dice_array_size):
		player_defense_dice_array_random.append(randi_range(1,6))
		
	for attack_dice in range(target_attack_dice_array_size):
		target_attack_dice_array_random.append(randi_range(1,6))
		
	for defense_dice in range(target_defense_dice_array_size):
		target_defense_dice_array_random.append(randi_range(1,6))
	
	print("original arrays: ")
	print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	print("target defender dice array: " + str(target_defense_dice_array_random) + "target attacker dice array: " + str(target_attack_dice_array_random))
	
	defender_chooses(player_attack_dice_array_random, player_defense_dice_array_random, target_attack_dice_array_random, target_defense_dice_array_random)
	
	print("after combat results: ")
	print("player attacker dice array: " + str(player_attack_dice_array_random) + " player defender dice array: " + str(player_defense_dice_array_random))
	print("target defender dice array: " + str(target_defense_dice_array_random) + "target attacker dice array: " + str(target_attack_dice_array_random))
	
	print("----------------")
	print("attack damage dealt from player to target: ")
	print("sum of player attack dice = " + str(sum_attack_array(player_attack_dice_array_random)) )
	print("the player's weapon's graze modifier is = " + str(player_weapon_graze_threshold) )
	print("target dodge threshold is = " + str(target_dodge_threshold))
	var target_adjusted_dodge_threshold: int = target_dodge_threshold - player_weapon_graze_threshold
	print("target's modified dodge threshold is = " + str(target_adjusted_dodge_threshold) )
	if sum_attack_array(player_attack_dice_array_random) - target_adjusted_dodge_threshold > 0:
		print("the player deals this much damage to the target = " + str( player_attack_dice_array_random.size() ) )
	else:
		print("the player dealt 0 or negative damage: " + str( player_attack_dice_array_random.size() ) )
	
	print("----------------")
	print("attack damage dealt from target to player: ")
	print("sum of player attack dice = " + str(sum_attack_array(target_attack_dice_array_random)) )
	print("the target's weapon's graze modifier is = " + str(target_weapon_graze_threshold) )
	print("player dodge threshold is = " + str(player_dodge_threshold))
	var player_adjusted_dodge_threshold: int = player_dodge_threshold - target_weapon_graze_threshold
	print("player's modified dodge threshold is = " + str(player_adjusted_dodge_threshold) )
	if sum_attack_array(target_attack_dice_array_random) - player_adjusted_dodge_threshold > 0:
		print("the target deals this much damage to the player = " + str( target_attack_dice_array_random.size() ) )
	else:
		print("the target dealt 0 or negative damage: " + str( target_attack_dice_array_random.size() ) )


