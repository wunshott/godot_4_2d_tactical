extends ItemSlot

class_name EquipSlot #For Armor Only

signal equip_item_to_player(limb:String, ItemToEquip: Item)
signal send_armor_hp_to_HUD(limb:String, EquippedArmor: Armor)

@export var limb_slot: String

# Called when the node enters the scene tree for the first time.
func _ready():
	get_allowed_limb_slot()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



func _can_drop_data(at_position: Vector2, data) -> bool: # overwrite function to add features
	var can_drop_bool: bool = false
	if data is ItemSlot and data.item_in_slot_resource.Equip_Slot == limb_slot:
		can_drop_bool = true
	
	return can_drop_bool #returns true (allows data drop) if the item is an item
	
func _refresh_slot():  # overwrite function to add features
	if !item_in_slot_resource: #refreshes item slot
		item_sprite.set_texture(null) 
		return
	item_sprite.set_texture(item_in_slot_resource.ItemSprite)
	equip_item_to_player.emit(limb_slot,item_in_slot_resource)
	send_armor_hp_to_HUD.emit(limb_slot, item_in_slot_resource)
	

func get_allowed_limb_slot() -> void:
	limb_slot = get_parent().get_parent().get_parent().get_name() #grab from a variable in the node instead of node name
	#TODO make a cleaner way to grab the limb name
