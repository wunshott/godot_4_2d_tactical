extends VBoxContainer

class_name ActionRollerMenu

signal player_action_rolled(dice_outcome_dictionary: Dictionary)
signal player_rolled_button

@onready var action_hbox_container = $PanelContainer/HBoxContainer/ActionBarHBoxContainer as HBoxContainer
@onready var dice_description_h_box = $DiceDescriptionHBox as HBoxContainer


@export var roll_count: int = 0
@export var action_rerolls: int = 2

@export var action_type_label: RichTextLabel # = $DiceDescriptionHBox/ActionDescriptionBox/HBoxContainer/VBoxContainer/ActionTypeLabel as Label


@export var action_description_panel_container: PanelContainer
@export var action_description: RichTextLabel
@export var dice_w_label: Label # = $DiceDescriptionHBox/PlayerDiceDescriptionBox/HBoxContainer/PanelContainer/VBoxContainer/DiceWLabel as Label
@export var reroll_count_label: Label # = $DiceDescriptionHBox/PlayerDiceDescriptionBox/HBoxContainer/PanelContainer/VBoxContainer/RerollCountLabel as Label




#@onready var attack_description_label = $ActionDescriptionBox/HBoxContainer/PanelContainer/VBoxContainer/AttackDescriptionLabel as RichTextLabel

@export var dice_container: GridContainer# = $DiceDescriptionHBox/DiceContainer/DiceContainer as GridContainer

@export var close_action_button: Button # = $PanelContainer/HBoxContainer/CloseActionButton as Button
@export var roll_selected_dice_button: Button #= $DiceDescriptionHBox/PlayerDiceDescriptionBox/HBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/RollSelectedDiceButton as Button
@export var stop_rolling_button: Button


@export var player_weapon: Weapon


var selected_action: Action
var dice_scene := load("res://HUD/Dice/dice_container.tscn")
var dice_outcome_array: Array[int]

func _ready():
	close_action_button.connect("pressed",Callable(dice_description_h_box,"hide"))
	close_action_button.connect("pressed",Callable(action_description_panel_container,"hide"))
	
	dice_description_h_box.hide()
	action_description_panel_container.hide()
	for children in action_hbox_container.get_children():
		children.queue_free()
	clear_dice_container()
	#connect_action_button_hover_to_description_box()
	
	
func set_selected_action(input_Action:Action) -> void:
	selected_action = input_Action

func clear_dice_container() -> void:
	for children in dice_container.get_children(): #clear dice in the array before adding a new one
		children.queue_free()

func toggle_dice_box() -> void:
	dice_description_h_box.set_visible(!dice_description_h_box.is_visible())


func update_action_dice_description(input_action: Action) -> void:
	#print_debug("signal worked")
	
	set_selected_action(input_action)
	dice_description_h_box.show()
	action_description_panel_container.show()
	
	
	show_stamina_dice(input_action.min_stamina_dice_cost)
	
	
	if input_action.attack_type == input_action.ATTACK_TYPE.Attack: #TODO use BBCode effects
		action_type_label.set_text( "Attack" )
	elif input_action.attack_type == input_action.ATTACK_TYPE.Defend:
		action_type_label.set_text( "Defend" )
	elif input_action.attack_type == input_action.ATTACK_TYPE.Fakeout:
		action_type_label.set_text( "Fakeout" )
	else:
		action_type_label.set_text( "etc" )
	
	dice_w_label.set_text("W: " + str(player_weapon.weapon_success_array))
	update_roll_label()
	action_description.set_text( str(input_action.action_name) + ": " + str(input_action.damage_description))

	
	return

func generate_action_buttons(input_actions: Array[Action]) -> void:
	for idx: Action in input_actions:
		var new_button = ActionButton.new()
		new_button.set_slotted_action(idx)
		action_hbox_container.add_child(new_button)
		new_button.set_tooltip_text(idx.mechanical_description)
		new_button.connect("pressed",Callable(self,"update_action_dice_description").bind(new_button.get_slotted_action()))
		
		#color code action based on type

func show_stamina_dice(stamina_cost: int) -> void:
	clear_dice_container()
	for idx: int in stamina_cost:
		var die: DieContainer = dice_scene.instantiate()
		die.connect("dice_rolled",Callable(self,"save_dice_outcome"))
		dice_container.add_child(die)

func save_dice_outcome(dice_outcome:int) -> void:
	dice_outcome_array.append(dice_outcome) #adds outcome to dice array

func sum_array(input_array: Array[int]) -> int:
	var array_sum: int 
	for idx: int in input_array:
		array_sum += idx
	
	return array_sum
	
func update_roll_label() -> void: #to be replaced with a meter
	reroll_count_label.set_text("Rerolls: " + str(action_rerolls - roll_count))


func _on_roll_selected_dice_button_pressed() -> void:
	

	if roll_count == 0: #the very first roll attempt. all dice must be rolled.
		dice_outcome_array.clear() #clear dice array before rolling a new one
		for dice_children: DieContainer in dice_container.get_children(): #TODO replace with groups?, put this into a function
			dice_children.set_dice_selection(true)
			dice_children.roll_die()
		
		var wepaon_success_array: Array[int] = player_weapon.weapon_success_array #TODO make this tied to the actual weapon
		var output_dict: Dictionary
		var number_of_w: int = 0
		var w_result: Array[int]
		for idx: int in dice_outcome_array: #TODO replcae with filter method
			if wepaon_success_array.has(idx) == true:
				number_of_w += 1
				w_result.append(idx)
		for dice_children: DieContainer in dice_container.get_children(): #
			for idx: int in wepaon_success_array:
				if dice_children.dice_outcome == idx:
					dice_children.gpu_particles_2d.set_emitting(true)
		
		output_dict["Ws"] = number_of_w
		output_dict["dice_result"] = dice_outcome_array
		output_dict["w_result"] = w_result
		output_dict["damage_dealt"] = sum_array(w_result)
		output_dict["Action"] = selected_action
		
		player_action_rolled.emit(output_dict) #TODO connect to parent
		player_rolled_button.emit() #this makes the mob dice roll. don't do this for the other rolls
		
		roll_count += 1 #increase roll_count by 1
		update_roll_label()

		
	elif roll_count > 0 and roll_count <= action_rerolls: #if you've rolled past your initial roll and have rolls left, callow dice to be selected and rolled
		dice_outcome_array.clear() #clear dice array before rolling a new one
		roll_selected_dice_button.set_disabled(true)
		for dice_children: DieContainer in dice_container.get_children():
				dice_children.roll_die() #"rolls" all dice. but only the selected dice get rerolled
		
		
		var wepaon_success_array: Array[int] = player_weapon.weapon_success_array #TODO make this tied to the actual weapon
		var output_dict: Dictionary
		var number_of_w: int = 0
		var w_result: Array[int]
		for idx: int in dice_outcome_array:
			if wepaon_success_array.has(idx) == true:
				number_of_w += 1
				w_result.append(idx)
		
		for dice_children: DieContainer in dice_container.get_children(): #
			for idx: int in wepaon_success_array:
				if dice_children.dice_outcome == idx:
					dice_children.gpu_particles_2d.set_emitting(true) #TODO when do i turn this off?
		
		output_dict["Ws"] = number_of_w
		output_dict["dice_result"] = dice_outcome_array
		output_dict["w_result"] = w_result
		output_dict["damage_dealt"] = sum_array(w_result)
		output_dict["Action"] = selected_action
		
		player_action_rolled.emit(output_dict) #TODO connect to parent
		
		roll_count += 1 #increase roll_count by 1
		update_roll_label()
	
	elif roll_count > 0 and roll_count > action_rerolls: #if you've exceeded your allowed reroll amount. TODO This should be checked after the dice rolls...
		roll_selected_dice_button.set_disabled(true) #disables roll button
		for child: Button in action_hbox_container.get_children():#disables action buttons to prevent dice respawn
			child.set_disabled(true)
		print_debug("confirm the dice matchup in the armor roller menu")
		#disable roll and stay buttons
		#prompt player to select the confirm button
	
	else:
		print_debug("this shouldn't be happeneing")
		print_debug(roll_count)
		print_debug(action_rerolls)
