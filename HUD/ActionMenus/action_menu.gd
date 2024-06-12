extends Control

class_name ActionMenu



@onready var hud_2: HUD = $".."
@onready var label = $PanelContainer/ListOfActions/ActionLineItem/Label
@onready var button = $PanelContainer/ListOfActions/ActionLineItem/Button
@onready var list_of_actions = $PanelContainer/ListOfActions

@onready var action_line_item = $PanelContainer/HBoxContainer/ActionLineItem

const ACTION_LINE_ITEM = preload("res://HUD/ActionMenus/action_line_item.tscn")


var CharacterSheetData: CharacterSheet

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func populate_actions_from_player() -> void:
	for actions: Action in CharacterSheetData.equipped_weapon_dictionary["right_arm"].Attacks:
		var new_attack_line: ActionLineItem = ACTION_LINE_ITEM.instantiate()
		list_of_actions.add_child(new_attack_line)
		fill_out_action_label(new_attack_line.label, actions.attack_name)
		new_attack_line.CharacterSheetData = CharacterSheetData
		


func _on_hud_2_recieved_char_sheet_from_player():
	CharacterSheetData = hud_2.CharacterSheetData
	populate_actions_from_player()

func fill_out_action_label(input_label: Label, action_name: String) -> void:
	input_label.set_text(action_name) #TODO create short hadn vairables for the weapons and attacks ocne the weapon is equipped
	


