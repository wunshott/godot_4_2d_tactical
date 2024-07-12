extends PanelContainer


@export var body: Control
@export var limb_description: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	#head.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(head.get_parent()))
	body.connect("limb_hovered",Callable(limb_description,"_update_description"))#.bind(player_data))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

