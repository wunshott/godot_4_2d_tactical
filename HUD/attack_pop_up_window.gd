extends Window

@export var window_type: Resource
#have resource files fill out the window type


# Called when the node enters the scene tree for the first time.
func _ready():
	return



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_close_requested():
	self.hide()



func _input(event: InputEvent):
	if event.is_action_pressed("Character_menu"):
		print("test")
		show()

	
	
