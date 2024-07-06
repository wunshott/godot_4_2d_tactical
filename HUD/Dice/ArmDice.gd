extends PanelContainer

class_name ArmDiceContainer

@onready var roll_dice: Button = $"../RollDice"

@export var DiceArray: Array[int]
@onready var arm_dice_pool = $ArmDicePool

var dice_container: PackedScene = preload("res://HUD/Dice/dice_container.tscn")


func create_dice_array() -> void:
	for die in DiceArray:
		var dice_to_add: DieContainer = dice_container.instantiate()
		dice_to_add.dice_number = die
		roll_dice.connect("pressed",Callable(dice_to_add,"update_dice_graphic"))
		
		
		arm_dice_pool.add_child(dice_to_add)

func _ready():
	create_dice_array()



func _can_drop_data(_at_position: Vector2, data) -> bool:
	return data is DieContainer 

func _drop_data(_at_position: Vector2, data) -> void:
	var dice_copy: DieContainer = dice_container.instantiate()
	dice_copy.dice_number = data.dice_number
	arm_dice_pool.add_child(dice_copy)
	data.animation_player.play("exiting") #deletes the original node


#func get_preview(item_dragged_texture: Texture2D):
	#return preview
