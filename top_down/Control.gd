extends Control

class_name UI

@export var character_menu_button: Button
@export var detailed_character_menu: Control
@export var detailed_character_menu_close_button: TextureButton

@export var detailed_character_limb_menu: LimbMenu

@export var player_character_data: CharacterSheet

@export var grid_coords_label: Label
@export var pixel_coords_label: Label


@onready var show_dice_button = $HBoxContainer/VBoxContainer/HBoxContainer2/PanelContainer/MarginContainer/VBoxContainer/ShowDiceButton as Button
@onready var dice_tray_roller = $DiceTrayRoller as DiceTray
@onready var rich_text_label = $HBoxContainer/VBoxContainer2/PanelContainer3/VBoxContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/RichTextLabel  as RichTextLabel
@onready var v_box_container_2 = $HBoxContainer/VBoxContainer2 as VBoxContainer
@onready var target_texture = $HBoxContainer/VBoxContainer2/VBoxContainer/PanelContainer4/VBoxContainer/TargetTexture as TextureRect
@onready var v_box_container = $HBoxContainer/VBoxContainer2/VBoxContainer as VBoxContainer


var text_window_size: int = 1:  #[ 0 = close, 1 = medium, 2 = large ]
	set = toggle_text_window_size


var is_char_menu_visible: bool = true


func _process(delta) -> void:
	pass
	
func update_grid_coords(mouse_pos: Vector2, end_pos: Vector2) -> void:
	grid_coords_label.set_text(str(end_pos))
	pixel_coords_label.set_text(str(mouse_pos)) 

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("pressed",Callable(self,"toggle_skill_visibility"))
	character_menu_button.connect("pressed",Callable(self,"toggle_character_visibility"))
	show_dice_button.connect("pressed",Callable(dice_tray_roller,"toggle_dice_menu"))
	detailed_character_menu_close_button.connect("pressed",Callable(self,"close_detailed_character_menu"))


	detailed_character_menu.set_visible(is_char_menu_visible)
	detailed_character_menu.hide()

func recieved_char_sheet(recieved_player_character_sheet: CharacterSheet) -> void:
	detailed_character_limb_menu.limb_description.player_data = recieved_player_character_sheet
	


func close_detailed_character_menu() -> void:
	detailed_character_menu.hide()
	detailed_character_menu_close_button.hide()

func toggle_character_visibility() -> void:
	#is_char_menu_visible = !is_char_menu_visible
	##var tween = get_tree().create_tween()
	#detailed_character_menu.set_visible(is_char_menu_visible)
	detailed_character_menu.set_visible(!detailed_character_menu.is_visible())
	if detailed_character_menu.is_visible():
		detailed_character_menu_close_button.show()
	else:
		detailed_character_menu_close_button.hide()
	if is_char_menu_visible:
		dice_tray_roller.dice_roller_tray_right = DiceTray.right_area.LARGE
	else:
		dice_tray_roller.dice_roller_tray_right = DiceTray.right_area.SMALL
		

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("Character_menu"):
		detailed_character_menu.set_visible(!detailed_character_menu.is_visible())
		if detailed_character_menu.is_visible():
			detailed_character_menu_close_button.show()
		else:
			detailed_character_menu_close_button.hide()
	

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


