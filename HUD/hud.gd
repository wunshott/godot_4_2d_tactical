extends Control

signal End_Turn_Button_Pressed

# Called when the node enters the scene tree for the first time.
@onready var grid_coords_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GridCoordsLabel
@onready var pixel_coords_label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/PixelCoordsLabel
@onready var stamina_label = $HP_and_Stamina/VBoxContainer/HBoxContainer2/StaminaLabel
@onready var texture_progress_bar = $HP_and_Stamina/VBoxContainer/HBoxContainer2/TextureProgressBar
@onready var stamina_label_text = $HP_and_Stamina/VBoxContainer/HBoxContainer2/TextureProgressBar/StaminaLabel

@onready var vats_menu = $VatsMenu
@onready var attack_menu = $Attack_Menu


@onready var description = $GameLogPanelContainer/VBoxContainer/ScrollContainer/Description

#const ATTACK_MENU = preload("res://HUD/attack_menu.tscn")
const ATTACK_MENU = preload("res://HUD/attack_menu.tscn")
const VATS_MENU = preload("res://HUD/Vats/vats_menu.tscn")


var grid_cords: Vector2
var pixel_cords: Vector2



func _ready():
	description.text = "Game events go here:\n"
	Dice_Roller.injury_table.connect("_injury_for_combat_dialogue_box",Callable(self,"_on_injury_for_combat_box"))
	Dice_Roller.connect("outcome_of_roll_combat_box", Callable(self,"_on_DiceRoller_string_for_combat_box"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_show_cords_on_screen(delta,grid_cords,pixel_cords)


func _show_cords_on_screen(delta, grid_cords: Vector2, pixel_cords: Vector2):# this function shows the current grid and pixel cooridnate of the mouse
	grid_coords_label.text = "x: " + str(grid_cords.x) + "," + "y: " + str(grid_cords.y)
	pixel_coords_label.text = "x: " + str(pixel_cords.x) + "," + "y: " + str(pixel_cords.y)


	


func _on_end_turn_pressed():
	End_Turn_Button_Pressed.emit()


func _on_player_fill_hud(stamina):
	stamina_label.text = "Stamina"
	texture_progress_bar.value = stamina
	texture_progress_bar.max_value = stamina
	stamina_label_text.text = str(stamina) + "/" + str(texture_progress_bar.max_value)
	

	
	#add a function to update the stamina as it changes


func _on_texture_progress_bar_value_changed(value):
	stamina_label_text.text = str(value) + "/" + str(texture_progress_bar.max_value)


func _on_player_stamina_used_for_moevement(stamina_changed):
	texture_progress_bar.value -= stamina_changed


func _add_text_to_dialogue(input_string: String, type = null,  placeholder = null) -> void: ##TODO update to sort the text into categories, fix placeholders
	description.add_text(str(input_string) + "\n") 

func _on_player_string_for_combat_box(input_string, type): #TODO change function name
	_add_text_to_dialogue(str(input_string) + "\n") 


func _on_stats_string_for_combat_box(input_string, type): #TODO change function name
	_add_text_to_dialogue(str(input_string) + "\n") 

func _on_injury_for_combat_box(input_string, type):
	_add_text_to_dialogue(str(input_string) + "\n") 

func _on_inventory_send_armor_damage_to_hud(ArmorDamage: int, ArmorName: String, ArmorBroken: bool):
	if ArmorBroken == false: 
		_add_text_to_dialogue("Target's " + str(ArmorName) + " armor took " + str(ArmorDamage) + " damage." + "\n") 
	else: # armor is broken
		_add_text_to_dialogue("Target's " + str(ArmorName) + " armor took " + str(ArmorDamage) + " damage." + " IT'S BROKEN!!" + "\n") 
	#TODO replace target with node name

func _on_DiceRoller_string_for_combat_box(input_string:String, type): #TODO change function name
	_add_text_to_dialogue(str(input_string) + "\n") 
