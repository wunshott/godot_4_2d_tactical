extends HBoxContainer
class_name dice_armor_pip_ui

# Called when the node enters the scene tree for the first time.


@onready var armor_dice_v_box_container = $"../../.." as VBoxContainer


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

func spawn_dice_from_equipped(limb_slot, item_in_slot_resource = null) -> void:
	if item_in_slot_resource is Weapon:
		CurrentDiceType =  DiceType.ATTACK
		generate_dice(CurrentDiceType,item_in_slot_resource.weapon_hit_die)
	elif  item_in_slot_resource is Armor:
		CurrentDiceType =  DiceType.DEFENSE
		generate_dice(CurrentDiceType,item_in_slot_resource.block_hit_die)
	
	else: #not weapon or armor
		CurrentDiceType = DiceType.NEITHER
		generate_dice(CurrentDiceType)

func generate_dice(dice_type: DiceType = DiceType.NEITHER,item_dice_array: Array[int] = []) -> void:
	armor_dice_v_box_container.show()
	CurrentDiceType = dice_type
	#print_debug(dice_type)
	#print_debug(item_dice_array)
	if CurrentDiceType == DiceType.ATTACK:
		dice_type_sprite.show()
		dice_type_sprite.set_texture(ATTACK_TEXTURE)
	elif CurrentDiceType == DiceType.DEFENSE:
		dice_type_sprite.show()
		dice_type_sprite.set_texture(DEFENSE_TEXTURE)
	else:
		#TODO what if the item equipped provides dice but isn't weapon,armor
		armor_dice_v_box_container.hide()
		dice_type_sprite.hide()
	for children in h_box_container.get_children():
		children.queue_free()
	#print_debug(item_dice_array)
	var container = DICE_ARMOR_PIPS_UI_CONTAINER.instantiate()
	container.update_dice_texture(item_dice_array) #sets the dice texture
	h_box_container.add_child(container)

		#TODO update code so it highlights the first dice in the array
		#will ahve to add a way to pop the first element
	
