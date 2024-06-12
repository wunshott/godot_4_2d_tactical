extends Panel

@onready var item_sprite:Sprite2D = $ItemSprite
@export var item_in_slot_resource: Item



signal equip_item_to_player(limb:String, ItemToEquip: Item)

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(item_sprite.texture)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _equip_item_to_limb() -> void: 
	var possible_equip_slots: String = item_in_slot_resource.Limb[0] 
	if !item_in_slot_resource:
		item_sprite.set_texture(null) 
		equip_item_to_player.emit("Head",item_in_slot_resource)
		return
	item_sprite.set_texture(item_in_slot_resource.ItemSprite)
	equip_item_to_player.emit("Head",item_in_slot_resource) 
	

func _refresh_slot(): 
	if get_parent().get_parent() is EquipSlot:
		var possible_equip_slots: String = item_in_slot_resource.Limb[0]
		for child in get_parent().get_parent().get_parent().get_parent().get_children(): #takes you to character body
			var equip_slot: String =  child.get_name() #TODO ensure this works for all limbs
			if equip_slot == possible_equip_slots: #TODO replace with class instead of node name?
				if !item_in_slot_resource:
					item_sprite.set_texture(null) 
					equip_item_to_player.emit(equip_slot,item_in_slot_resource)
					return
				item_sprite.set_texture(item_in_slot_resource.ItemSprite)
				equip_item_to_player.emit(equip_slot,item_in_slot_resource) 
	
	else: # allows you to swap inventory items around. 
		if !item_in_slot_resource:
			item_sprite.set_texture(null) 
			return
		item_sprite.set_texture(item_in_slot_resource.ItemSprite)
		

#TODO change the panel so it can only accept certain types of limbs depending on the placement
#head, legs, etc
