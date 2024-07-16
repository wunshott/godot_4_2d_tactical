extends Control

class_name AttackMenu

signal request_player_attack_actions

@export var ActionType: Resource

@onready var list_of_actions = $PanelContainer/ListOfActions
@onready var dice_roller = $"../DiceRoller"


var is_dragging: bool = false
var offset: Vector2
var current_array_of_actions: Array = []
var background_total_hit_chance: int

const ATTACK_MENU_ITEM = preload("res://HUD/ActionMenus/attack_menu_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_visible(false)
	#_connect_signals_to_player_inventory()
	#get access to the player. change to a function
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dragging:
		if Input.is_action_just_pressed("left_click"):
			offset = get_global_mouse_position() - global_position
		if Input.is_action_pressed("left_click"):
			global_position = get_global_mouse_position() - offset
		

func _input(event):
	if event.is_action_pressed("attack_menu"):
		request_player_attack_actions.emit()

func _refresh_attacks_weapon_swap():
	return
func _update_hit_chance_for_attacks(current_hit_chance: int):
	return # THC needs to update with player stat changes and weapon swap. should not stack with pushing A
	for child in list_of_actions:
		child.hit_chance_label.set_text(str(background_total_hit_chance + current_hit_chance))

func _on_stats_thc_to_send(current_hit_chance: int):
	_update_hit_chance_for_attacks(current_hit_chance)


func add_attack_actions_to_hud(ArrayofActions: Array, weapon_hit_bonus:int, weapon_icon:Texture2D, attacker_base_hit_bonus:int) -> void: # adds the actions to the attack menu
	#clear out the children before adding new ones
	
	for action: Action in ArrayofActions:
		var new_attack_line: AttackList = ATTACK_MENU_ITEM.instantiate()
		list_of_actions.add_child(new_attack_line)
		
		background_total_hit_chance = weapon_hit_bonus + action.attack_hit_chance + attacker_base_hit_bonus #weapon and action hit bonus. The dice roller calls the player hit chance since that changes
		#make into a different function 
		new_attack_line.attack_name.set_text(action.attack_name) #breaks if the label is moved from its current location
		new_attack_line.attack_button.texture_normal = weapon_icon 
		new_attack_line.attack_button.set_tooltip_text(action.damage_description)
		new_attack_line.attack_name.set_tooltip_text(action.damage_description)
		new_attack_line.armor_damage_label.set_text(str(action.damage_armor))
		new_attack_line.stamina_damage_label.set_text(str(action.damage_stamina))
		new_attack_line.stamina_cost_label.set_text(str(action.stamina_cost))
		new_attack_line.range_label.set_text(str(action.aoe_range))
		new_attack_line.damage_type_label.set_text(action.damage_type)
		new_attack_line.hit_chance_label.set_text(str(background_total_hit_chance))
		new_attack_line.attack_resource = action
		new_attack_line.current_total_hit_bonus = background_total_hit_chance
		
	self.set_visible(true)

func map_modifiers_to_attack():
	return
	#ensure the modifiers are attached to the attack, but sent separately when the dice_roller recieves it
	# what happens if the hit chance changes?

func _on_close_menu_button_pressed(): #close the menu out
	Dice_Roller.attack_lock = false #cancels the attack lock when the menu is closed
	for child in list_of_actions.get_children(): #kills all the children in the list of actions that are type AttackList (leaves the cancel button and demo)
		if child is AttackList:
			child.queue_free()
	self.set_visible(false)

#needs to connect to the player node
#when spawned, it sends a signal to the player node
#this signal activates a function in the player node
#it sends the attack_menu a signal back with the data it requests
#grab the actions from its weapons (inventory)
#grab actions native to the player
# create labels for each one


#figure out a way to move, drag and drop 


func _on_panel_container_mouse_entered():
	is_dragging = true


func _on_panel_container_mouse_exited():
	is_dragging = false



func _on_enemy_activate_attack_menu():
	request_player_attack_actions.emit() # remove this once the attack action range menu is fixed, same for vats menu

#send_attack_hud_actions(attack_action_array:Array[Action], weapon_hit_bonus:int, attacker_base_hit_bonus:int)
func _on_inventory_send_attack_hud_actions(ArrayofActions: Array, weapon_hit_bonus:int,weapon_icon:Texture2D, attacker_base_hit_bonus:int):
	if current_array_of_actions.is_same_typed(ArrayofActions): #if the array recieved is the same as the current one, do nothing
		return
	# if the current array is different, send it through
	add_attack_actions_to_hud(ArrayofActions, weapon_hit_bonus, weapon_icon, attacker_base_hit_bonus)
	
	current_array_of_actions.clear()
	current_array_of_actions.append_array(ArrayofActions)


