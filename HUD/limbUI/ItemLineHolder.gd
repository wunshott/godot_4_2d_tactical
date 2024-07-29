extends VBoxContainer


#item info
@export var description_panel_item_name: Label
@export var description_panel_item_description: Label
@export var description_panel_item_lore: Label
@export var description_panel_item_equipslot: Label
@export var description_panel_item_size: Label
@export var description_panel_dice: dice_armor_pip_ui

#@export var inventory_panel: ItemSlot # have these connect to the panel container when the item slot spawns in.
#probably have a limited quantity of each type spawn in. color code basd on size. all connect when spawning in
@export var item_description_panel: PanelContainer
const IRON_CHEST_PLATE = preload("res://top_down/Items/Armor/iron_Chest_plate.tres")
const IRON_HELMET = preload("res://top_down/Items/Armor/iron_helmet.tres")
@onready var test_item_array: Array[Item] = [ IRON_CHEST_PLATE,IRON_HELMET ]

# Called when the node enters the scene tree for the first time.
func _ready():
	for itemlines in get_children():
		for child in itemlines.get_children():
			if child is ItemSlot:
				itemlines.connect("mouse_entered",Callable(self,"_update_item_description_panel").bind(child))
				if test_item_array:
					child.add_item_to_slot(test_item_array.pop_front())



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_close_button_pressed():
	item_description_panel.hide()

func _update_item_description_panel(item_slot: ItemSlot) -> void:
	
	if !item_slot.item_in_slot_resource: #if no item exists
		item_description_panel.hide()
		return
		
	item_description_panel.show()
	description_panel_item_name.set_text(item_slot.item_in_slot_resource.ItemName)
	description_panel_item_description.set_text(item_slot.item_in_slot_resource.ItemDescription)
	
	description_panel_item_lore.set_text(item_slot.item_in_slot_resource.ItemLore) #have the lore menu be a dropdown
	description_panel_item_equipslot.set_text(item_slot.item_in_slot_resource.Equip_Slot)
	description_panel_item_size.set_text(item_slot.item_in_slot_resource.ItemSize) #convey item size through a different means?
	
	if item_slot.item_in_slot_resource is Weapon:
		#add a sword icon?
		#print_debug("item is a weapon")
		#print_debug(inventory_panel.item_in_slot_resource.weapon_hit_die)
		#description_panel_dice.CurrentDiceType = description_panel_dice.DiceType.ATTACK 
		description_panel_dice.generate_dice(description_panel_dice.DiceType.ATTACK, item_slot.item_in_slot_resource.weapon_hit_die)
	
	elif item_slot.item_in_slot_resource is Armor:
		#description_panel_dice.CurrentDiceType = description_panel_dice.DiceType.DEFENSE 
		description_panel_dice.generate_dice(description_panel_dice.DiceType.DEFENSE ,item_slot.item_in_slot_resource.block_hit_die)
	
	else:
		print_debug("item is not armor or weapon")
