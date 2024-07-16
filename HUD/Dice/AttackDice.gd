extends PanelContainer

class_name AttackDiceContainer


@onready var roll_dice: Button = $"../../VBoxContainer/RollDice"
@onready var reset_dice = $"../../../ResetDice" as Button

var dice_container: PackedScene = preload("res://HUD/Dice/dice_container.tscn")

@onready var v_box_container_2 = $VBoxContainer2
@export var DiceArray: Array[int]


func _can_drop_data(_at_position: Vector2, data) -> bool:
	return data is DieContainer 

func _drop_data(_at_position: Vector2, data) -> void:
	var dice_copy: DieContainer = dice_container.instantiate()
	dice_copy.dice_number = data.dice_number
	
	v_box_container_2.add_child(dice_copy)
	roll_dice.connect("pressed",Callable(dice_copy,"roll_dice"))
	dice_copy.connect("send_dice_outcome",Callable(self,"compile_dice_outcomes"))
	
	
	data.animation_player.play("exiting") #deletes the original node
	
	
	#item_dropped_on_target.emit(data)


func compile_dice_outcomes(dice_outcome:int) -> void:
	DiceArray.append(dice_outcome)

	
