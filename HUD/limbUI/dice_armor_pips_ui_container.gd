extends HBoxContainer

class_name dice_armor_pip_ui_container




const dice_dictionary_gfx: Dictionary = {
	1:preload("res://assets/test_dice/dice_1.png"),
	2:preload("res://assets/test_dice/dice_2.png"),
	3:preload("res://assets/test_dice/dice_3.png"),
	4:preload("res://assets/test_dice/dice_4.png"),
	5:preload("res://assets/test_dice/dice_5.png"),
	6:6,
	7:7,
	8:8,
	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	#for child in get_children():
		#child.queue_free() #clears the children
	#update_dice_texture([2, 3, 4])
	#print_debug(atlas_dice_texture.texture)
	#update_dice_texture(3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_dice_texture(dice_group: Array[int]) -> void:
	for dice_value in dice_group:
		var item_dice := TextureRect.new()
		item_dice.set_texture(dice_dictionary_gfx[dice_value])
		add_child(item_dice)
		
	
	
