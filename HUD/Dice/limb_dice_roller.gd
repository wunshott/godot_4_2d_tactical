extends Control



#@onready var enemy: PlayerRoller = $Enemy
#@onready var player: PlayerRoller = $Player

@export var enemy: PlayerRoller
@export var player: PlayerRoller






func _ready():
	player.add_items(enemy)
	enemy.add_items(player)



func calc_damage(attack_roller: PlayerRoller, defense_roller: PlayerRoller) -> void:
	#var attacker = attack_roller.combatant_class
	#var defender = defense_roller.combatant_class
	
	var attack_sum: int = sum_attack_array(attack_roller.attack_dice_pool.DiceArray)
	
	
	if attack_sum < defense_roller.combatant_class.dodge:
		var defender_adjusted_dodge_threshold: int = defense_roller.combatant_class.dodge - attack_roller.combatant_class.equipped_right_arm_weapon.weapon_graze #dual wielding?
		var attacker_damage_dealt: int = attack_sum - ( defender_adjusted_dodge_threshold ) #TODO pick the lowest of threshold when compared to the weapon graze
		#print("target's modified dodge threshold is = " + str(target_adjusted_dodge_threshold) )
		#print("the combatant deals this much damage target = " + str(player_damage_dealt ) )
		print(str(attack_roller.combatant_class.name) + " damage = "  + str(attacker_damage_dealt))
		defense_roller.combatant_class.focus_max_element(defense_roller.combatant_class.limb_dictionary[attack_roller.targeted_limb],clamp(attacker_damage_dealt,0,999) )
	
	else:
		var attacker_damage_dealt: int = attack_sum - defense_roller.combatant_class.dodge 
		#print("the combatant deals this much damage to target = " + str(player_damage_dealt ) )
		print(str(attack_roller.combatant_class.name) + " damage = "  + str(attacker_damage_dealt))
		defense_roller.combatant_class.focus_max_element(defense_roller.combatant_class.limb_dictionary[attack_roller.targeted_limb],clamp(attacker_damage_dealt,0,999) )
	
	#update health, dodge, stamina, DT after getting attacked
	defense_roller.combatant_class.set_HP()
	defense_roller.combatant_class.set_dodge()
	defense_roller.combatant_class.set_stamina()
	defense_roller.update_stamina_pool_in_container()

func roll_limb_dice(input_array: Array[int]) -> Array[int]:
	var output_array: Array[int] = []
	for element in input_array:
		var dice_outomce: int = randi_range(1,element)
		output_array.append(dice_outomce)
	return output_array
	
func _on_button_pressed():
	test_roll_func()

func test_roll_func() -> void:
	var player_defense: Array[int] = []
	var enemy_defense: Array[int] = []
	
	player_defense.append_array(player.defense_dice_pool.DiceArray)
	enemy_defense.append_array(enemy.defense_dice_pool.DiceArray)
	
	var player_temp_armor: Array[int] = roll_limb_dice(player.combatant_class.equipped_armor_dictionary[enemy.targeted_limb])
	var enemy_temp_armor: Array[int] = roll_limb_dice(enemy.combatant_class.equipped_armor_dictionary[player.targeted_limb])
	
	
	player_defense.append_array(player_temp_armor)
	enemy_defense.append_array(enemy_temp_armor)

	
	print("player attack dice: " + str(player.attack_dice_pool.DiceArray) + " enemy defense dice: " + str(enemy_defense) )
	print("enemy attack dice: " + str(enemy.attack_dice_pool.DiceArray) + " player defense dice: " + str(player_defense) )
	
	defender_chooses(player.attack_dice_pool.DiceArray,enemy_defense)
	defender_chooses(enemy.attack_dice_pool.DiceArray,player_defense)
	
	print("player attack dice: " + str(player.attack_dice_pool.DiceArray) + " enemy defense dice: " + str(enemy_defense) )
	print("enemy attack dice: " + str(enemy.attack_dice_pool.DiceArray) + " player defense dice: " + str(player_defense) )
	
	print("before combat")
	print("player limb dice: " + str(player.combatant_class.limb_dictionary[enemy.targeted_limb]) )
	print("enemy limb dice: " + str(enemy.combatant_class.limb_dictionary[player.targeted_limb]) )
	
	calc_damage(player,enemy)
	calc_damage(enemy,player)
	
	print("-----------------------")
	print("after combat")
	print( str(player.combatant_class.name) + " limb dice: " + str(player.combatant_class.limb_dictionary[enemy.targeted_limb]) )
	print( str(enemy.combatant_class.name) + " limb dice: " + str(enemy.combatant_class.limb_dictionary[player.targeted_limb]) )

func defender_chooses(attack_dice_array: Array[int], defender_dice_array: Array[int]):
	var defender_dice_array_copy: Array[int] = []
	var attacker_dice_array_copy: Array[int] = []
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

func sum_attack_array(attack_dice: Array[int]) -> int:
	var attack_damage: int = 0
	for dice in attack_dice:
		attack_damage += dice
	return attack_damage

