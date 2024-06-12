extends Control

@export var Dice: int

@onready var v_box_container_2 = $HBoxContainer/AttackDice/VBoxContainer2


var dragged_dice: DieContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	for dice in v_box_container_2.get_children():
		if dice is DieContainer:
			dice.connect("gui_input",Callable(self,"_on_dice_gui_input").bind(dice))

func _on_dice_gui_input(event: InputEvent, dice: DieContainer):
	print(dice)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _get_drag_data(at_position: Vector2): 
	#
	#return #inventory_panel
#
#func _can_drop_data(at_position: Vector2, data) -> bool:
	#return data is ItemSlot #returns true (allows data drop) if the item is an item
#
#func _drop_data(at_position: Vector2, data): # assign variable name to data. resource file item
	#return
#
##func get_preview(item_dragged_texture: Texture2D):
	##return preview
