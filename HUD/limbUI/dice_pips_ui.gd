extends HBoxContainer

class_name dice_pip_ui

const DICE_PIP_UI_CONTAINER = preload("res://HUD/limbUI/dice_pip_ui_container.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for children in get_children():
		children.queue_free() #clear placeholder children upon startup
	pass # Replace with function body.


# Called every frame. 'delt"res://assets/test_dice/dicce.png"a' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_dice(total_dice: Array[int]) -> void:
	for children in get_children():
		children.queue_free() #clear dice before adding more
	for dice_idx in total_dice:
		var container = DICE_PIP_UI_CONTAINER.instantiate()
		container.update_dice_texture(dice_idx) #sets the dice texture
		add_child(container)
