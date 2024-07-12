extends VBoxContainer

@export var player_data: Class
@export var limb_title: Label

@export var equipped_weapon_title: Label #TODO create these but for weapons
@export var equpped_weapon_dice: HBoxContainer



@onready var dice_pips_ui = $LimbExplanation/VBoxContainer/HBoxContainer/PanelContainer2/DicePipsUi as dice_pip_ui
@onready var dice_armor_pips_ui = $LimbExplanation/VBoxContainer/HBoxContainer2/PanelContainer4/DiceArmorPipsUi as dice_armor_pip_ui
@onready var dice_item_pips_ui = $LimbExplanation/VBoxContainer/HBoxContainer3/PanelContainer4/DiceArmorPipsUi as dice_armor_pip_ui


enum limb_type {NONE, HEAD, TORSO, RIGHT_ARM, LEFT_ARM, RIGHT_LEFT, LEFT_LEG} #TODO replace string checks with enum states.

var current_displayed_limb : limb_type
# Called when the node enters the scene tree for the first time.
func _ready():
	player_data.initialize_limb_hp()
	#print_debug(player_data.equipped_weapon_dictionary["left_arm"].weapon_hit_die)
	#print_debug(player_data.limb_dictionary["head"])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _update_description(input_limb: String) -> void:
	limb_title.set_text(input_limb)
	dice_pips_ui.generate_dice(player_data.limb_dictionary[input_limb]) #pass the player's limb dice 
	dice_armor_pips_ui.generate_dice(player_data.equipped_armor_dictionary[input_limb]) #pass the player's armor dice
	
	# if input_limb is a weapon, populate
	if input_limb == "left_arm" or input_limb == "right_arm":
		#TODO show the equpped weapon dice section
		equipped_weapon_title.show()
		equpped_weapon_dice.show()
		dice_item_pips_ui.generate_dice(player_data.equipped_weapon_dictionary[input_limb].weapon_hit_die) 
		
	else:
		equipped_weapon_title.hide()
		equpped_weapon_dice.hide()
		return
		#TODO hide the equipped weapon dice section
		
