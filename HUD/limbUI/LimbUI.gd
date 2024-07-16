extends PanelContainer
class_name LimbMenu

@onready var h_box_container = $HBoxContainer/VBoxContainer/HBoxContainer as HBoxContainer #contains the toggle buttons

@export var body: Control
@export var limb_description: VBoxContainer

@export var inventory_toggle_button: Button
@export var equipped_item_description_button: Button

@export var inventory_menu: PanelContainer
@export var limb_explanation_menu: PanelContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	#head.connect("mouse_entered",Callable(self,"_on_limb_mouse_entered").bind(head.get_parent()))
	body.connect("limb_hovered",Callable(limb_description,"_update_description"))#.bind(player_data))
	inventory_toggle_button.connect("toggled",Callable(self,"toggle_inventory_menu"))
	equipped_item_description_button.connect("toggled",Callable(self,"toggle_limb_menu"))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func populate_inventory_slot(input_item: Item) -> void:
	
	return

#func test(input_bool: bool) -> void:
	#for child in h_box_container.get_children():
		#if child is Button:
			#if child.is_pressed:
				#child.set_pressed(false)
	
	

func toggle_limb_menu(input_bool: bool) -> void:
	if input_bool:
		inventory_toggle_button.set_pressed(false)
		inventory_menu.hide()
		limb_explanation_menu.show()

func toggle_inventory_menu(input_bool: bool) -> void:
	if input_bool:
		equipped_item_description_button.set_pressed(false)
		limb_explanation_menu.hide()
		inventory_menu.show()
