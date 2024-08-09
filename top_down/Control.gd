extends Control

class_name UI



@export var character_menu_button: Button
@export var detailed_character_menu: Control
@export var detailed_character_menu_close_button: TextureButton

@export var detailed_character_limb_menu: LimbMenu

@export var player_character_data: CharacterSheet

@export var grid_coords_label: Label
@export var pixel_coords_label: Label

@export var action_roller_menu_container: PanelContainer
@export var action_roller_menu: ActionRollerMenu
@export var show_battle_action_button: Button
@export var armor_roller_menu: ArmorRollerMenu
@export var combat_handler: CombatHandler

@onready var dice_tray_roller = $DiceTrayRoller as DiceTray
@onready var rich_text_label = $HBoxContainer/VBoxContainer2/PanelContainer3/VBoxContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/RichTextLabel  as RichTextLabel
@onready var v_box_container_2 = $HBoxContainer/VBoxContainer2 as VBoxContainer
@onready var target_texture = $HBoxContainer/VBoxContainer2/VBoxContainer/PanelContainer4/VBoxContainer/TargetTexture as TextureRect
@onready var v_box_container = $HBoxContainer/VBoxContainer2/VBoxContainer as VBoxContainer


var player_outcome_roll: Dictionary

var text_window_size: int = 1:  #[ 0 = close, 1 = medium, 2 = large ]
	set = toggle_text_window_size


var is_char_menu_visible: bool = true

#TODO make the text log a separate window?

func update_grid_coords(mouse_pos: Vector2, end_pos: Vector2) -> void:
	grid_coords_label.set_text(str(end_pos))
	pixel_coords_label.set_text(str(mouse_pos)) 

# Called when the node enters the scene tree for the first time.
func _ready():
	player_character_data.initiate_char()

	init_player_gear()
	
	show_battle_action_button.connect("pressed",Callable(self,"toggle_combat_action_menu"))
	character_menu_button.connect("pressed",Callable(self,"toggle_character_visibility"))
	detailed_character_menu_close_button.connect("pressed",Callable(self,"close_detailed_character_menu"))
	dice_tray_roller.connect("all_dice_rolled",Callable(self,"print_dice_rolls")) #defunct
	
	
	#connect player roller and armor roller signals to each other
	action_roller_menu.connect("player_action_rolled",Callable(self,"load_player_roll_outcome")) #loads player outcome
	armor_roller_menu.connect("mob_action_rolled",Callable(self,"load_mob_roll_outcome")) #loads mob outcome
	action_roller_menu.connect("player_rolled_button",Callable(armor_roller_menu,"_on_roll_mob_dice_pressed")) #rolls enemy and player dice at the same time
	action_roller_menu.connect("player_action_rolled",Callable(self,"print_data_to_textbox")) #prints rolls to the text box
	
	action_roller_menu.generate_action_buttons(player_character_data.combat_action_array) #generate action bar
	
func load_player_roll_outcome(player_roll_dictionary: Dictionary) -> void:
	player_outcome_roll = player_roll_dictionary
	#print_debug(player_outcome_roll)
	

func load_mob_roll_outcome(mob_roll_dictionary: Dictionary) -> void:
	var mob_outcome_roll = mob_roll_dictionary
	combat_handler.compare_actions(player_outcome_roll,mob_outcome_roll) # add a basic node to handle this logic. contained in UI
	#print_debug(mob_outcome_roll)


func toggle_combat_action_menu() -> void:
	action_roller_menu_container.set_visible(!action_roller_menu_container.is_visible())

func recieved_char_sheet(recieved_player_character_sheet: CharacterSheet) -> void:
	detailed_character_limb_menu.limb_description.player_data = recieved_player_character_sheet
	
func init_player_gear() -> void:
	for armor: Armor in player_character_data.equipped_armor_dictionary.values():
		detailed_character_limb_menu.update_limb_slot_from_player(armor)
		
	
	for weapon: Weapon in player_character_data.equipped_weapon_dictionary.values(): 
		detailed_character_limb_menu.update_limb_slot_from_player(weapon)

func close_detailed_character_menu() -> void:
	detailed_character_menu.hide()
	detailed_character_menu_close_button.hide()

func toggle_character_visibility() -> void:
	#is_char_menu_visible = !is_char_menu_visible
	##var tween = get_tree().create_tween()
	#detailed_character_menu.set_visible(is_char_menu_visible)
	detailed_character_menu.set_visible(!detailed_character_menu.is_visible())


		

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("Character_menu"):
		detailed_character_menu.set_visible(!detailed_character_menu.is_visible())
		if detailed_character_menu.is_visible():
			detailed_character_menu_close_button.show()
		else:
			detailed_character_menu_close_button.hide()
	

	#character_menu.set_visible(is_char_menu_visible)
func print_data_to_textbox(input_data:Variant) -> void:
	if input_data is Dictionary:
		rich_text_label.append_text(" Player rolled " + str(input_data) )

func print_player_position(current_position: Vector2) -> void:
	rich_text_label.append_text(" I moved to " + str(current_position) )
	rich_text_label.newline()

func print_dice_rolls(player_attack_dice_array: Array, player_defense_dice_array: Array) -> void:
	rich_text_label.append_text(" Player rolled " + str(player_attack_dice_array) + " for attack")
	rich_text_label.newline()
	rich_text_label.append_text(" Player rolled " + str(player_defense_dice_array) + " for defense")
	rich_text_label.newline()
	

func _on_expand_text_pressed():
	if text_window_size == 0:
		text_window_size = 1
	elif text_window_size == 1:
		text_window_size = 2
	else:
		return
		
	
		

func toggle_text_window_size(value: int):
	text_window_size = value
	if text_window_size == 0:
		v_box_container_2.set_visible(false)
	elif text_window_size == 1:
		v_box_container_2.set_visible(true)
		v_box_container_2.size_flags_stretch_ratio = .25
	else:
		v_box_container_2.set_visible(true)
		v_box_container_2.size_flags_stretch_ratio = .5
		



func _on_minimize_text_pressed():
	if text_window_size == 2:
		text_window_size = 1
	elif text_window_size == 1:
		text_window_size = 0
	else:
		return
	
	

func update_target_texture(area: Area2D) -> void:
	v_box_container.set_visible(true)
	target_texture.texture = area.get_parent().target_sprite


func _on_button_pressed():
	v_box_container.set_visible(false)


