extends HBoxContainer

@onready var ItemNameLabel = $ItemName as Label
@onready var ItemSizeLabel = $ItemSize as Label
@onready var inventory_panel = $InventoryPanel as ItemSlot


func _ready() -> void:
	inventory_panel.connect("item_added_to_slot",Callable(self,"_update_item_description"))
	_update_item_description()
	



func _update_item_description() -> void:
	if inventory_panel.item_in_slot_resource: #if an item exists
		ItemNameLabel.set_text(inventory_panel.item_in_slot_resource.ItemName)
		ItemSizeLabel.set_text(inventory_panel.item_in_slot_resource.ItemSize)
	else: #no item, keep blank
		ItemNameLabel.set_text("No Item")
		ItemSizeLabel.set_text("...")
