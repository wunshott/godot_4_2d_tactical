extends Control

class_name ItemSlot

@onready var inventory_panel = $"."
@onready var item_sprite = $PanelContainer/item_sprite as TextureRect

@export var item_in_slot_resource: Item#: set = add_item_to_slot

signal item_added_to_slot(item_name: String, item_size: String)

# Called when the node enters the scene tee for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_item_to_slot(input_item: Item) -> void:
	item_in_slot_resource =  input_item
	_refresh_slot()




func _get_drag_data(at_position: Vector2): 
	if !item_in_slot_resource:
		return
	set_drag_preview(get_preview(item_in_slot_resource.ItemSprite))
	return self


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
	item_added_to_slot.emit()
	if !item_in_slot_resource: #refreshes item slot
		item_sprite.set_texture(null)
		return
	item_sprite.set_texture(item_in_slot_resource.ItemSprite)
	

	
