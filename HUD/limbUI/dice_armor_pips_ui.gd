extends HBoxContainer
class_name dice_armor_pip_ui

# Called when the node enters the scene tree for the first time.

@onready var h_box_container = $PanelContainer/HBoxContainer as HBoxContainer
@export var dice_type_sprite: TextureRect
@export var CurrentDiceType := DiceType.NEITHER

const DICE_ARMOR_PIPS_UI_CONTAINER = preload("res://HUD/limbUI/dice_armor_pips_ui_container.tscn")

const ATTACK_TEXTURE = preload("res://assets/customs/attack_texture.png")
const DEFENSE_TEXTURE = preload("res://assets/customs/defense_texture.png")

enum DiceType {NEITHER, ATTACK, DEFENSE}


func _ready():
	for children in h_box_container.get_children():
		children.queue_free() #clear placeholder children upon startup
	#generate_dice_groups([ [3,2], [4,1], [5,4,1]])


func _process(delta):
	pass
# [ [3, 2], [4, 2], [1, 2] ]
func generate_dice(item_dice_array: Array[int]) -> void:
	if CurrentDiceType == DiceType.ATTACK:
		dice_type_sprite.show()
		dice_type_sprite.set_texture(ATTACK_TEXTURE)
	elif CurrentDiceType == DiceType.DEFENSE:
		dice_type_sprite.show()
		dice_type_sprite.set_texture(DEFENSE_TEXTURE)
	else:
		dice_type_sprite.hide()
	for children in h_box_container.get_children():
		children.queue_free()
	#print_debug(item_dice_array)
	var container = DICE_ARMOR_PIPS_UI_CONTAINER.instantiate()
	container.update_dice_texture(item_dice_array) #sets the dice texture
	h_box_container.add_child(container)

		#TODO update code so it highlights the first dice in the array
		#will ahve to add a way to pop the first element
	
