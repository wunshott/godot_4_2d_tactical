extends Control


@export var character_menu_button: Button
@export var detailed_character_menu: Control
@export var detailed_character_menu_button: TextureButton
@export var limb_menu_button: Button
@export var inventory_menu_button: Button

@export var limb_menu: PanelContainer
@export var inventory_menu: PanelContainer

@onready var show_dice_button = $HBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/ShowDiceButton as Button
@onready var dice_tray_roller = $DiceTrayRoller as DiceTray
@onready var rich_text_label = $HBoxContainer/VBoxContainer2/PanelContainer3/VBoxContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/RichTextLabel  as RichTextLabel
@onready var v_box_container_2 = $HBoxContainer/VBoxContainer2 as VBoxContainer
@onready var target_texture = $HBoxContainer/VBoxContainer2/VBoxContainer/PanelContainer4/VBoxContainer/TargetTexture as TextureRect
@onready var v_box_container = $HBoxContainer/VBoxContainer2/VBoxContainer as VBoxContainer


var text_window_size: int = 1:  #[ 0 = close, 1 = medium, 2 = large ]
	set = toggle_text_window_size


var is_char_menu_visible: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("pressed",Callable(self,"toggle_skill_visibility"))
	character_menu_button.connect("pressed",Callable(self,"toggle_character_visibility"))
	show_dice_button.connect("pressed",Callable(dice_tray_roller,"toggle_dice_menu"))
	detailed_character_menu_button.connect("pressed",Callable(self,"close_detailed_character_menu"))
	#TODO make 1 toggle menu function that closes/opens the node 
	limb_menu_button.connect("pressed",Callable(self,"toggle_limb_menu"))
	inventory_menu_button.connect("pressed",Callable(self,"toggle_inventory_menu"))
	
	detailed_character_menu.set_visible(is_char_menu_visible)
	detailed_character_menu.hide()

func toggle_limb_menu() -> void:
	inventory_menu_button.set_pressed_no_signal(false)
	inventory_menu.hide()
	limb_menu.show()

func toggle_inventory_menu() -> void:
	limb_menu_button.set_pressed_no_signal(false)
	limb_menu.hide()
	inventory_menu.show()



func close_detailed_character_menu() -> void:
	detailed_character_menu.hide()
	detailed_character_menu_button.hide()

func toggle_character_visibility() -> void:
	#is_char_menu_visible = !is_char_menu_visible
	##var tween = get_tree().create_tween()
	#detailed_character_menu.set_visible(is_char_menu_visible)
	detailed_character_menu.set_visible(!detailed_character_menu.is_visible())
	if detailed_character_menu.is_visible():
		detailed_character_menu_button.show()
	else:
		detailed_character_menu_button.hide()
	if is_char_menu_visible:
		dice_tray_roller.dice_roller_tray_right = DiceTray.right_area.LARGE
	else:
		dice_tray_roller.dice_roller_tray_right = DiceTray.right_area.SMALL
		

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("Character_menu"):
		detailed_character_menu.set_visible(!detailed_character_menu.is_visible())
		if detailed_character_menu.is_visible():
			detailed_character_menu_button.show()
		else:
			detailed_character_menu_button.hide()
	

	#character_menu.set_visible(is_char_menu_visible)

func print_player_position(current_position: Vector2) -> void:
	rich_text_label.append_text(" I moved to " + str(current_position) )
	rich_text_label.newline()


func _on_expand_text_pressed():
	if text_window_size == 0:
		text_window_size = 1
	elif text_window_size == 1:
		text_window_size = 2
	else:
		return
		
	
		

func toggle_text_window_size(value: int):
	text_window_size = value
	if text_window_size == 0:
		v_box_container_2.set_visible(false)
		print_debug("true")
		dice_tray_roller.dice_roller_tray_left = DiceTray.left_area.LARGE
	elif text_window_size == 1:
		v_box_container_2.set_visible(true)
		v_box_container_2.size_flags_stretch_ratio = .25
		dice_tray_roller.dice_roller_tray_left = DiceTray.left_area.MED
	else:
		v_box_container_2.set_visible(true)
		v_box_container_2.size_flags_stretch_ratio = .5
		dice_tray_roller.dice_roller_tray_left = DiceTray.left_area.SMALL
		



func _on_minimize_text_pressed():
	if text_window_size == 2:
		text_window_size = 1
	elif text_window_size == 1:
		text_window_size = 0
	else:
		return
	
	

func update_target_texture(area: Area2D) -> void:
	v_box_container.set_visible(true)
	target_texture.texture = area.get_parent().target_sprite


func _on_button_pressed():
	v_box_container.set_visible(false)


