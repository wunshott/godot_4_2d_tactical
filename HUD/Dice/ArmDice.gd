extends PanelContainer

@onready var h_box_container = $HBoxContainer
@export var DiceArray: Array[int]

var dragged_node: DieContainer = null
# Called when the node enters the scene tree for the first time.
func create_dice_array() -> void:
	#go through children
	#find each dice container
	#grab their dice number and append to this DiceArray
	return
func connect_gui_input_children() -> void:
	for child in h_box_container.get_children():
		if child is DieContainer:
			child.connect("gui_input",Callable(self,"_on_child_gui_input"))

func _on_child_gui_input(event: InputEvent, child: Node):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		#start dragging
		dragged_node = child
		return

func _ready():
	connect_gui_input_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_drag_data(at_position: Vector2):
	
	return dragged_node

func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is DieContainer 

func _drop_data(at_position: Vector2, data): 
	if data:
		var dropped_node = data as DieContainer
		if dropped_node:
			h_box_container.add_child(dropped_node)
		
	return

#func get_preview(item_dragged_texture: Texture2D):
	#return preview
