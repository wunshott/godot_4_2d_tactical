extends PanelContainer

class_name LimbMenu

@export var head_ui: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#TODO draw center makes mouse enter/leave finnicky. pick the right control node for the moues to enter
#ideally a panel container



func _on_head_mouse_entered():
	for child in head_ui.get_children():
		if child is PanelContainer:
			child.get_child(0).show()


func _on_head_mouse_exited():
	for child in head_ui.get_children():
		if child is PanelContainer:
			child.get_child(0).hide()
