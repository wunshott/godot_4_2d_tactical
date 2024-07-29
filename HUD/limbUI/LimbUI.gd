extends PanelContainer
class_name LimbMenu

@onready var h_box_container = $HBoxContainer/VBoxContainer/HBoxContainer as HBoxContainer #contains the toggle buttons
@onready var ui = $"../../.." as UI




@export var body: Control
@export var limb_description: VBoxContainer

@export var inventory_toggle_button: Button
@export var equipped_item_description_button: Button

@export var inventory_menu: PanelContainer
@export var limb_explanation_menu: PanelContainer

@onready var encumbrance_label = $HBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer/EncumbranceLabel as Label
@onready var dice_armor_ui = $HBoxContainer/LimbDescription/LimbExplanation/VBoxContainer/ArmorDiceVBoxContainer/HBoxContainer2/PanelContainer4/DiceArmorPipsUi as dice_armor_pip_ui

# Called when the node enters the scene tree for the first time.
func _ready():
	#head.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(head.get_parent()))
	
	#player_data.connect("armor_equipped",Callable(self,"update_limb_slot_from_player"))
	#player_data.connect("weapon_equipped",Callable(self,"update_limb_slot_from_player"))
	#for armor: Armor in player_data.equipped_armor_dictionary.values():
		#print_debug(armor.ItemName)
	if ui:
		limb_description.player_data = ui.player_character_data
	if body:
		body.connect("limb_selected",Callable(limb_description,"_update_description"))#.bind(ui.player_character_data))
	inventory_toggle_button.connect("toggled",Callable(self,"toggle_inventory_menu"))
	equipped_item_description_button.connect("toggled",Callable(self,"toggle_limb_menu"))
	limb_description.player_data.connect("encumbrance_changed",Callable(self,"update_encumbrance"))
	
	#connects limb equip menu to the limb description menu
	#place all the equip slots in a group
	var equip_slot_nodes := get_tree().get_nodes_in_group("equip_slot")
	for node:EquipSlot in equip_slot_nodes:
		node.connect("item_equipped_by_player",Callable(ui.player_character_data,"equip_item"))
		node.connect("item_equipped_by_player",Callable(dice_armor_ui,"spawn_dice_from_equipped"))
		node.connect("item_unequipped_by_player",Callable(ui.player_character_data,"unequip_item"))
		node.connect("item_unequipped_by_player",Callable(dice_armor_ui,"spawn_dice_from_equipped"))
	
	#print_debug(ui.player_character_data.equipped_armor_dictionary["right_arm"].currently_equipped_slot)
	
	#for weapon: Weapon in ui.player_character_data.equipped_weapon_dictionary.values():
		#update_limb_slot_from_player(weapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_encumbrance(current_player_encumbrance: int) -> void:
	encumbrance_label.set_text("Total Armor Encumbrance: " + str(current_player_encumbrance))

func update_limb_slot_from_player(item_to_equip: Item) -> void:
	var equip_slot_nodes := get_tree().get_nodes_in_group("equip_slot")
	for node:EquipSlot in equip_slot_nodes:
		if node.limb_slot == item_to_equip.currently_equipped_slot:
			node.add_item_to_slot(item_to_equip)


func toggle_limb_menu(input_bool: bool) -> void:
	if input_bool:
		inventory_toggle_button.set_pressed(false)
		inventory_menu.hide()
		limb_explanation_menu.show()

func toggle_inventory_menu(input_bool: bool) -> void:
	if input_bool:
		equipped_item_description_button.set_pressed(false)
		limb_explanation_menu.hide()
		inventory_menu.show()

