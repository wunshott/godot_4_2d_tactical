extends Control

class_name VATS


signal placeholder_defend(number_of_bonus_dice: int)

var is_dragging: bool = false
var offset: Vector2

# click on an attack
# click on vats body part, (check if attack was clicked, offer way to cancel)
# dice roller in player is told to roll dice
# damage is done


@onready var hud_2 = $".."

#references to the button textures
@onready var head = $Panel/VBoxContainer/GridContainer/Head
@onready var head_armor_hp = $Panel/VBoxContainer/GridContainer/HeadArmorHp

@onready var torso = $Panel/VBoxContainer/GridContainer/Torso

#fix these
@onready var right_arm = $Panel/CenterContainer/GridContainer/RightArm
@onready var left_arm = $Panel/CenterContainer/GridContainer/LeftArm
@onready var groin = $Panel/CenterContainer/GridContainer/Groin
@onready var right_leg = $Panel/CenterContainer/GridContainer/RightLeg
@onready var left_leg = $Panel/CenterContainer/GridContainer/LeftLeg


@onready var stamina_bar = $Panel/VBoxContainer/HPDTSTAMINA/Stamina/StaminaBar
@onready var stamina_bar_label = $Panel/VBoxContainer/HPDTSTAMINA/Stamina/StaminaBar/StaminaBarLabel

@onready var hp_label: Label = $Panel/VBoxContainer/HPDTSTAMINA/HBoxContainer/HPLabel
@onready var test_hp_dt_bar: HPDTBar = $Panel/VBoxContainer/HPDTSTAMINA/HBoxContainer/test_hp_dt_bar



@export var TargetSheetData: CharacterSheet

var dodge_AC: int

func _ready():
	self.set_visible(false)
	self.connect("placeholder_defend",Callable(Dice_Roller,"roll_defend"))
	#TODO setup the signals from the resource file to update the HUD


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dragging:
		if Input.is_action_just_pressed("left_click"):
			offset = get_global_mouse_position() - global_position
		if Input.is_action_pressed("left_click"):
			global_position = get_global_mouse_position() - offset


func _connect_to_enemy_signals() -> void:
	#this function should connect to an enemy once the enemy is right clicked
	return
	
func _calculate_hit_chance_on_limb() -> void:
	#finds the hit % for each limb based on all variables and displays the number
	return


func _highlight_limb_when_mouse_hovers() -> void:
	#highlight the limb the mouse hovers over
	return

func _talk_to_injury_table() -> void:
	#ensures injuries are displayed on the vats body
	return

func _attack_selected(selected_attack) -> void:
	print(selected_attack)


func _on_panel_mouse_entered():
	is_dragging = true


func _on_panel_mouse_exited():
	is_dragging = false


func _on_enemy_activate_vats_menu():
	self.set_visible(true)


func _on_cancel_button_pressed(): #close the menu
	self.set_visible(false)


func _on_head_pressed():
	var target_dodge_dice: int = TargetSheetData.get_dodge_dice()
	var target_block_dice: int = TargetSheetData.equipped_armor_dictionary["head"].block_hit_die
	placeholder_defend.emit(target_dodge_dice, target_block_dice) #grabs the target's armor dice + dodge dice

func _on_torso_pressed():
	return
	Dice_Roller._on_get_target_limb("Torso",torso.ArmorSlot,dodge_AC)


func _populate_armor(ArmorDictionary: Dictionary):
	head.ArmorSlot = ArmorDictionary.get("Head")
	_adjust_armor_hp_bar(head_armor_hp, head.ArmorSlot)
	
	torso.ArmorSlot = ArmorDictionary.get("Torso")
	#right_arm.ArmorSlot = ArmorDictionary.get("RightArm") TODO unsupress these and copy the same texture button node
	#left_arm.ArmorSlot = ArmorDictionary.get("LefttArm")
	#groin.ArmorSlot = ArmorDictionary.get("Groin")
	#right_leg.ArmorSlot = ArmorDictionary.get("RightLeg")
	#left_leg.ArmorSlot = ArmorDictionary.get("LeftLeg")

func _adjust_armor_hp_bar(Armorbar: TextureProgressBar, ArmorPiece: Armor): #TODO figure out a way to set the max hp when the bar is initilaized
	Armorbar.set_value(ArmorPiece.armor_hp)
	



func _on_enemy_send_vats_ac(EquippedArmor: Dictionary, DodgeChance: int):
	_populate_armor(EquippedArmor)
	dodge_AC = DodgeChance


func _set_stamina_bar_max(max_stamina) -> void:
	stamina_bar.set_max(max_stamina)


func _on_stats__send_max_stamina_to_char_sheet(max_stamina: int): 
	_set_stamina_bar_max(max_stamina)
	stamina_bar.set_value(max_stamina)


func _on_stats_stamina_to_send_to_hud(current_stamina: int):
	stamina_bar.set_value(current_stamina)
	stamina_bar_label.text = str(current_stamina)


func populate_vats_menu() -> void:
	stamina_bar_label.set_text( str(TargetSheetData.get_stamina()) +  "/" + str(TargetSheetData.get_max_stamina()))
	stamina_bar.set_value( TargetSheetData.get_stamina() )
	stamina_bar.set_max( TargetSheetData.get_max_stamina() )
	
	hp_label.set_text( "HP: " + str( TargetSheetData.get_HP() ) )
	test_hp_dt_bar.hp_bar.set_value(TargetSheetData.get_HP())
	test_hp_dt_bar.hp_bar.set_max( TargetSheetData.get_max_HP() )
	
	test_hp_dt_bar.dt_bar.set_value(TargetSheetData.get_DT())
	test_hp_dt_bar.dt_bar.set_max(TargetSheetData.get_max_HP()) #max DT is max HP
	
	
	

func _on_hud_2_recieved_char_sheet_from_target():
	TargetSheetData = hud_2.TargetSheetData
	populate_vats_menu()
