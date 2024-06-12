extends PanelContainer

class_name DiceArrayContainer

signal child_gui_input(event: InputEvent, child: Node)  # Custom signal

@onready var v_box_container_2 = $VBoxContainer2
@export var DiceArray: Array[int]

# Called when the node enters the scene tree for the first time.

func create_dice_array() -> void:
	#go through children
	#find each dice container
	#grab their dice number and append to this DiceArray
	return
	

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



