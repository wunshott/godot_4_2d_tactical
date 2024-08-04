extends Node


class_name Stats
#put all the character stat stuff in this script
signal fill_hud(stamina)
signal stamina_used_for_moevement(stamina_changed)
signal armor_damaged(damage:int, armor:Armor)
signal string_for_combat_box(text: String, TextType: String)
signal stamina_to_send(current_stamina:int)
signal stamina_to_send_to_hud(current_stamina:int) 
signal _send_max_stamina_to_char_sheet(max_stamina: int)
signal THC_to_send(current_hit_chance:int)

@onready var inventory = $"../Inventory"

#make this a separate scene

@export var CharacterSheetData: CharacterSheet




#Coordination


#Armor value


## SETTERS GETTERS

#movement


func populate_character():
	return
	
	#print(limb_dictionary)

	#movement_pool = clampi(speed,0,text_max_movement)

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ensure the appropriate values are passed to the vats_menu
# take damage, drain stamin, do actions, etc should be from the stats script

