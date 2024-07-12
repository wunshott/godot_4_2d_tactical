extends HBoxContainer
class_name dice_pip_ui_container

@export var dice_texture: TextureRect
@export var pip_texture: TextureRect

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
	#print_debug(atlas_dice_texture.texture)
	#update_dice_texture(3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_dice_texture(dice_max_value: int) -> void:
	dice_texture.set_texture(dice_dictionary_gfx[dice_max_value])
