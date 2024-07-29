extends ItemSlot

class_name EquipSlot #For Armor Only

signal item_equipped_by_player(limb: String, item: Item)
signal item_unequipped_by_player(limb: String)
signal send_armor_hp_to_HUD(limb:String, EquippedArmor: Armor)


@export var limb_slot: String

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_allowed_limb_slot()
	#_refresh_slot()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

#TODO should the equipped item open in the limb or inventory screen?
#maybe hovering the mouse over an item will open the inventory screen
#hovering the limb shoudl highlight, but clicking on the limb will show the limb screen

func add_item_to_slot(input_item: Item) -> void:
	item_in_slot_resource =  input_item
	item_sprite.set_texture(item_in_slot_resource.ItemSprite)


func _drop_data(at_position: Vector2, data): # assign variable name to data. resource file item
	var temp = item_in_slot_resource
	
	self.item_in_slot_resource = data.item_in_slot_resource
	data.item_in_slot_resource = temp #swaps the files around. the dragged goes to destination and destination goes to dragged. 
	
	data._refresh_slot() #resets both slots so the sprites update with the resource
	self._refresh_slot()

func _can_drop_data(at_position: Vector2, data) -> bool: # overwrite function to add features
	var can_drop_bool: bool = false
	if data is ItemSlot and data.item_in_slot_resource.Equip_Slot == limb_slot: #TODO need to set a better condition for this. 
		can_drop_bool = true
	
	return can_drop_bool #returns true (allows data drop) if the item is an item
	
func _refresh_slot():  # overwrite function to add features
	if !item_in_slot_resource: #refreshes item slot
		#item was unequipped
		item_unequipped_by_player.emit(limb_slot)
		if item_sprite:
			item_sprite.set_texture(null) 
		return
		
	#item was equipped
	
	item_sprite.set_texture(item_in_slot_resource.ItemSprite)
	item_equipped_by_player.emit(limb_slot, item_in_slot_resource)
	
	#print_debug(limb_slot) #TODO why?


