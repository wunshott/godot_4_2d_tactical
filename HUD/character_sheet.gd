extends Control

class_name CharacterSheetHUD

@onready var hud_2 = $".."

@onready var stamina_bar_label: Label = $TabBar/TabContainer/Stats/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/PanelContainer/HPArmor/Stamina/StaminaBar/StaminaBarLabel
@onready var stamina_bar_label_max: Label = $TabBar/TabContainer/Stats/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/PanelContainer/HPArmor/Stamina/StaminaBar/StaminaBarLabel_MAX
@onready var inventory_ui = $TabBar/TabContainer/Stats/MarginContainer/VBoxContainer/HBoxContainer2/VboxContainer/InventoryUI
@onready var character_body = $TabBar/TabContainer/Stats/MarginContainer/VBoxContainer/HBoxContainer2/CharacterBody
@onready var stamina_bar: TextureProgressBar = $TabBar/TabContainer/Stats/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/PanelContainer/HPArmor/Stamina/StaminaBar
@onready var hp: Label = $TabBar/TabContainer/Stats/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/PanelContainer/HPArmor/HPandDT/HP
@onready var test_hp_dt_bar: HPDTBar = $TabBar/TabContainer/Stats/MarginContainer/VBoxContainer/HBoxContainer/GridContainer/PanelContainer/HPArmor/HPandDT/test_hp_dt_bar


@export var CharacterSheetData: CharacterSheet

#TODO replace the names in the characterbody with things you can find when equipping items

var isInventoryOpen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#TODO push the UI to separate windows
##Stamina Updating Functions
func _on_stats_stamina_to_send_to_hud(current_stamina: int):
	stamina_bar.set_value(current_stamina)
	stamina_bar_label.text = str(current_stamina)


func _set_stamina_bar_max(max_stamina: int): 
	stamina_bar.set_max(max_stamina)
	stamina_bar_label_max.text = (str(max_stamina))


func _on_stats_send_max_stamina_to_char_sheet(max_stamina: int):
	_set_stamina_bar_max(max_stamina)


## HP/DT Updating Functions
func on_stats_set_max_HP(value: int) -> void:
	hp.set_text("HP: " + str(value))
	test_hp_dt_bar.hp_bar.set_max(value)
	test_hp_dt_bar.dt_bar.set_max(value)


func on_stats_set_HP(value: int) -> void:
	hp.set_text("HP: " + str(value))
	test_hp_dt_bar.hp_bar.set_value(value)

## DT
func on_stats_set_DT(value: int):
	test_hp_dt_bar.dt_bar.set_value(value)



func _on_inventory_pressed():
	toggle_inventory()

func toggle_inventory() -> void:
	isInventoryOpen = not isInventoryOpen
	inventory_ui.set_visible(isInventoryOpen)


func _on_inventory_send_invetory_to_hud(player_inventory:Array):
	inventory_ui.inventory_passed_from_player.append_array(player_inventory)
	inventory_ui.update()



func _on_hud_2_recieved_char_sheet_from_player():
	CharacterSheetData = hud_2.CharacterSheetData
	CharacterSheetData.connect("max_stamina_changed",Callable(self,"_on_stats_send_max_stamina_to_char_sheet"))
	CharacterSheetData.connect("stamina_changed",Callable(self,"_on_stats_stamina_to_send_to_hud"))
	CharacterSheetData.connect("max_HP_changed",Callable(self,"on_stats_set_max_HP"))
	CharacterSheetData.connect("HP_changed",Callable(self,"on_stats_set_HP"))
	CharacterSheetData.connect("DT_changed",Callable(self,"on_stats_set_DT"))
