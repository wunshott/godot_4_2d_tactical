extends VBoxContainer

@export var arm_dice: Array[int]
@export var stamina_dice: Array[int]


# Called when the node enters the scene tree for the first time.
func _ready():
	return
	#current_dice.set_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func roll_limb_dice(input_array: Array) -> Array:
	var output_array: Array
	for element in input_array:
		var dice_outomce: int = randi_range(1,element)
		output_array.append(dice_outomce)
	return output_array
