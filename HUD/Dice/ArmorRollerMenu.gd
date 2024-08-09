extends PanelContainer

class_name ArmorRollerMenu

signal mob_action_rolled

#values that should be derived from parents
@export var MobActions: Array[Action]
@export var MobWeapon: Weapon


#references to children in this node
@export var EnemyActionLabel: Label
@export var MobDiceContainer: HBoxContainer
@export var MobWArrayLabel: Label
@export var PlayerArmorPointsLabel: Label 

@export var ArmorPointsValue: int = 5: set = update_armor_points, get = get_armor_points #input value will increase or decrease the value
@export var MaxArmorPoints: int = 5 #TODO need to clamp this value to a player can't push the button if its = 0. button call needs to check armor points


@export var RollMobDice: Button

const ARMOR_DICE_POINT_CONTAINER = preload("res://HUD/ActionMenus/armor_dice_point_container.tscn")

var dice_outcome_array:Array[int]
var adjusted_dice_outcome_array: Array[int]
var mob_action: Action: set = set_mob_action
var can_player_use_armor_points: bool = false: set = player_can_use_armor

func _ready():
	clear_armor_dice_containers()
	
	PlayerArmorPointsLabel.set_text(str(get_armor_points())) 
	
	mob_action = select_an_attack(MobActions)
	EnemyActionLabel.set_text(mob_action.action_name)
	MobWArrayLabel.set_text(str(MobWeapon.weapon_success_array))
	
	#for children in MobDiceContainer.get_children():
		#children.queue_free()
	#
	#for idx:int in mob_action.min_stamina_dice_cost: #adds dice
		#var die: DieContainer = dice_scene.instantiate()
		#die.dice_max = 6
		#die.connect("dice_rolled",Callable(self,"save_dice_outcome"))
		#MobDiceContainer.add_child(die)
	
	#TODO 
	#spawn dice from the action
	#roll the dice with action stamina cost
	#allow player to edit the dice rolls with armor hp
	#make this the new outcome roll
	#Send this roll and the action type to the parent node
	#Send player roll and action type to the parent node
	#compare rolls according to rps logic
	#deal damage
func player_can_use_armor(value: bool) -> void: #disables all the armor buttons if the player can't use armor. disables/enables all at once
	for idx: ArmorDicePointContainer in MobDiceContainer.get_children():
		idx.toggle_armor_buttons(value)

func update_armor_points(value: int) -> void:
	ArmorPointsValue = clamp(value,0,MaxArmorPoints)
	PlayerArmorPointsLabel.set_text(str(get_armor_points()))
	
func get_armor_points() -> int:
	return ArmorPointsValue

func clear_armor_dice_containers() -> void:
	for children in MobDiceContainer.get_children(): #clear out editor dice
		children.queue_free()

func select_an_attack(input_action_array:Array[Action]) -> Action:
	var action_selectd: Action = input_action_array[randi_range(0,input_action_array.size()-1)] #select a random action
	return action_selectd


func save_dice_outcome(dice_outcome:int) -> void:
	dice_outcome_array.append(dice_outcome) #adds outcome to dice array

func set_mob_action(selected_action:Action) -> void:
	mob_action = selected_action
	clear_armor_dice_containers() #clear all dice containers before generating a new one
	#create dice
	for idx: int in mob_action.min_stamina_dice_cost:
		var armor_point_container :ArmorDicePointContainer = ARMOR_DICE_POINT_CONTAINER.instantiate()
		armor_point_container.create_die(idx)
		MobDiceContainer.add_child(armor_point_container)
		armor_point_container.dice_container.connect("dice_rolled",Callable(self,"save_dice_outcome"))
		armor_point_container.dice_container.connect("die_outcome_changed",Callable(self,"recalc_dice_outcome"))
		
		#armor_point_container.dice_container.roll_die()

func recalc_dice_outcome() -> void: #recalcs the array
	adjusted_dice_outcome_array.clear()
	for armor_container: ArmorDicePointContainer in MobDiceContainer.get_children():
		adjusted_dice_outcome_array.append(armor_container.dice_container.dice_outcome)
	
	for armor_container: ArmorDicePointContainer in MobDiceContainer.get_children(): #TODO move this logic to the dice rolled. feed it the W conditions, if it lands, sparkle
		if MobWeapon.weapon_success_array.find(armor_container.dice_container.dice_outcome) != -1: 
			armor_container.dice_container.gpu_particles_2d.set_emitting(true) 
		else:
			armor_container.dice_container.gpu_particles_2d.set_emitting(false)
	
	var armor_point_array: Array[int]
	var array_index: int = 0
	for idx:int in adjusted_dice_outcome_array: 
		armor_point_array.append( abs(idx - dice_outcome_array[array_index]) )
		array_index += 1
	
	update_armor_points(MaxArmorPoints - sum_array(armor_point_array))
	PlayerArmorPointsLabel.set_text( str(get_armor_points()))# - sum_array(armor_point_array)) )#just shows what the armor value is.
	
	
	
	#print_debug("spent " + str(sum_array(armor_point_array)) + " armor points")
	
func _on_roll_mob_dice_pressed() -> void: #rolls all the mob dice, may need reroll logic
	dice_outcome_array.clear() #clear dice array before rolling a new one
	
	
	for idx: ArmorDicePointContainer in MobDiceContainer.get_children():
		idx.dice_container.is_selected = true
		idx.dice_container.roll_die() # will append the dice outcome array
	
	for armor_container: ArmorDicePointContainer in MobDiceContainer.get_children(): #
		for idx: int in MobWeapon.weapon_success_array:
			if armor_container.dice_container.dice_outcome == idx:
				armor_container.dice_container.gpu_particles_2d.set_emitting(true) #TODO when do i turn this off?

	player_can_use_armor(true) #enables button


func sum_array(input_array: Array[int]) -> int:
	var array_sum: int 
	for idx: int in input_array:
		array_sum += idx
	return array_sum
	
	
	


func _on_button_pressed() -> void: #confirm button
	#once the dice are confirmed 
	#send the output array with the adjusted dice rolls to the action compare
	#subtract points spent from armor hp
	
	player_can_use_armor(false) #disables button
	
	var weapon_success_array: Array[int] = MobWeapon.weapon_success_array
	var output_dict: Dictionary
	var number_of_w: int = 0
	var w_result: Array[int]
	#var adjusted_dice_outcome: Array[int] = adjusted_dice_outcome_array #need to adjust after the user confirms their armor dice pool usage. create a new array that holds the adjusted values

	#print_debug("adjusted array " + str(adjusted_dice_outcome_array) )
	#print_debug("original array " + str(dice_outcome_array) )
	#if adjusted_dice_outcome_array == dice_outcome_array:
		#print_debug("true")

	
	if !adjusted_dice_outcome_array:
		output_dict["dice_result"] = dice_outcome_array
		for idx: int in weapon_success_array:
			number_of_w += dice_outcome_array.count(idx)
		for idx: int in dice_outcome_array:
			if weapon_success_array.has(idx) == true:
				w_result.append(idx)
		
	else:
		output_dict["dice_result"] = adjusted_dice_outcome_array #adjusted dice result
		for idx: int in weapon_success_array:
			number_of_w += adjusted_dice_outcome_array.count(idx)
		for idx: int in adjusted_dice_outcome_array:
			if weapon_success_array.has(idx) == true:
				w_result.append(idx)
	


	output_dict["Ws"] = number_of_w
	output_dict["w_result"] = w_result
	output_dict["damage_dealt"] = sum_array(w_result)
	output_dict["Action"] = mob_action
	
	print_debug(output_dict)
	
	
	mob_action_rolled.emit(output_dict) #TODO connect to parent


func _on_reset_button_pressed():
	adjusted_dice_outcome_array.clear()
	adjusted_dice_outcome_array = dice_outcome_array.duplicate(true)
	
	for armor_container: ArmorDicePointContainer in MobDiceContainer.get_children(): #
		if MobWeapon.weapon_success_array.find(armor_container.dice_container.dice_outcome) != -1: 
			armor_container.dice_container.gpu_particles_2d.set_emitting(true) 
		else:
			armor_container.dice_container.gpu_particles_2d.set_emitting(false)
	
	var child_index: int = 0
	for idx: int in dice_outcome_array:
		MobDiceContainer.get_child(child_index).get_child(1).dice_outcome = idx #replace with groups?
		MobDiceContainer.get_child(child_index).get_child(1).set_die_gfx()
		child_index += 1
	update_armor_points(MaxArmorPoints)
