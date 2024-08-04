extends VBoxContainer


@export var limb_title: Label


@export var dice_pips_ui: dice_pip_ui
@export var dice_armor_pips_ui: dice_armor_pip_ui
@export var dice_item_pips_ui: dice_armor_pip_ui

@export var limb_dice_container: VBoxContainer
@export var armor_dice_container: VBoxContainer
@export var item_dice_container: VBoxContainer

var player_data: CharacterSheet

enum limb_type {NONE, HEAD, TORSO, RIGHT_ARM, LEFT_ARM, RIGHT_LEFT, LEFT_LEG} #TODO replace string checks with enum states.

var current_displayed_limb : limb_type
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#print_debug(player_data.equipped_weapon_dictionary["left_arm"].weapon_hit_die)
	#print_debug(player_data.limb_dictionary["head"])
	pass # Replace with function body.




func _update_description(input_limb: String) -> void:
	limb_title.set_text(input_limb)
	
	#if player_data.limb_dictionary[input_limb]:
	dice_pips_ui.generate_dice(player_data.limb_dictionary[input_limb]) #pass the player's limb dice

	if input_limb in player_data.equipped_armor_dictionary:
		armor_dice_container.show()
		#dice_armor_pips_ui.CurrentDiceType = dice_armor_pips_ui.DiceType.DEFENSE
		
		dice_armor_pips_ui.generate_dice( dice_armor_pips_ui.DiceType.DEFENSE,player_data.equipped_armor_dictionary[input_limb].block_hit_die) #pass the player's armor dice TODO will need to update as the armor changes
	else:
		armor_dice_container.hide()
	
	
	if input_limb == "right_arm":
		if "right_hand" in player_data.equipped_weapon_dictionary:
			item_dice_container.show()
			#dice_item_pips_ui.CurrentDiceType = dice_item_pips_ui.DiceType.ATTACK
			dice_item_pips_ui.generate_dice(dice_item_pips_ui.DiceType.ATTACK,player_data.equipped_weapon_dictionary["right_hand"].weapon_hit_die)
		else:
			item_dice_container.hide()
	elif input_limb == "left_arm":
		if "left_hand" in player_data.equipped_weapon_dictionary:
			item_dice_container.show()
			#dice_item_pips_ui.CurrentDiceType = dice_item_pips_ui.DiceType.ATTACK
			dice_item_pips_ui.generate_dice(dice_item_pips_ui.DiceType.ATTACK,player_data.equipped_weapon_dictionary["left_hand"].weapon_hit_die)
		else:
			item_dice_container.hide()
	

	else:
		item_dice_container.hide()
	
	# if input_limb is a weapon, populate
	#if input_limb == "left_arm" or input_limb == "right_arm":
		#equipped_weapon_title.show()
		#equpped_weapon_dice.show()
		#if player_data.equipped_weapon_dictionary[input_limb]:
			#dice_armor_pips_ui.CurrentDiceType = dice_armor_pips_ui.DiceType.ATTACK
			#dice_item_pips_ui.generate_dice(player_data.equipped_weapon_dictionary[input_limb].weapon_hit_die)
		#
	#else:
		#equipped_weapon_title.hide()
		#equpped_weapon_dice.hide()
		#return
		#
