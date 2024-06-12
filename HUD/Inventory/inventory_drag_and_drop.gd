extends Control

class_name ItemSlot

@onready var inventory_panel = $"."
@onready var item_sprite = $item_sprite
@export var item_in_slot_resource: Item

signal unequip_item_to_player(limb:String, ItemToEquip: Item)


# Called when the node enters the scene tee for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update(item): 
	if item is Item:
		item_in_slot_resource = item
		item_sprite.texture = item_in_slot_resource.ItemSprite 
		#item_sprite.set_visible(true)
	else:
		item_in_slot_resource = null
		#item_sprite.set_visible(false)
		item_sprite.set_texture(null)
	




func _get_drag_data(at_position: Vector2): 
	set_drag_preview(get_preview(item_in_slot_resource.ItemSprite))

	return inventory_panel


func _can_drop_data(at_position: Vector2, data) -> bool:

	return data is ItemSlot #returns true (allows data drop) if the item is an item
	
	
func _drop_data(at_position: Vector2, data): # assign variable name to data. resource file item
	var temp = item_in_slot_resource
	self.item_in_slot_resource = data.item_in_slot_resource
	data.item_in_slot_resource = temp #swaps the files around. the dragged goes to destination and destination goes to dragged. 
	data._refresh_slot() #resets both slots so the sprites update with the resource
	self._refresh_slot()

func get_preview(item_dragged_texture: Texture2D):
	var preview_texture_node = TextureRect.new()
	
	preview_texture_node.texture = item_dragged_texture
	preview_texture_node.expand_mode = 1
	preview_texture_node.size = Vector2(48,48)
	
	var preview = Control.new()
	preview.add_child(preview_texture_node)
	return preview
	
func _refresh_slot(): 
	if !item_in_slot_resource: #refreshes item slot
		item_sprite.set_texture(null) 
		return
	item_sprite.set_texture(item_in_slot_resource.ItemSprite)
	
	if item_in_slot_resource is Weapon:
		var limb_slot = item_in_slot_resource.currently_equipped_hand #allows weapon to be place in either hand
		print(limb_slot)
		unequip_item_to_player.emit(limb_slot,item_in_slot_resource)
	else:
		var limb_slot = item_in_slot_resource.Equip_Slot
		unequip_item_to_player.emit(limb_slot,item_in_slot_resource)

