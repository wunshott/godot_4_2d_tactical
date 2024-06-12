extends EquipSlot

class_name WeaponEquipSlot

signal equip_weapon_to_player(limb:String, ItemToEquip: Item)


var weapon_equip_slot: String

# Called when the node enters the scene tree for the first time.
func _ready():
	get_allowed_limb_slot()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _refresh_slot():  # overwrite function to add features
	if !item_in_slot_resource: #refreshes item slot
		item_sprite.set_texture(null) 
		return
	item_sprite.set_texture(item_in_slot_resource.ItemSprite)
	
	
	equip_weapon_to_player.emit(weapon_equip_slot,item_in_slot_resource)
	item_in_slot_resource.currently_equipped_hand = weapon_equip_slot #fills the weapon slot with where its currently equipped so its communicated to other nodes


func get_allowed_limb_slot() -> void:
	weapon_equip_slot = self.get_name()
	#TODO make a cleaner way to grab the limb name
