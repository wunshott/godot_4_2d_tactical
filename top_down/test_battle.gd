extends Node2D

@onready var path = $Path
@onready var tile_map = $TileMap

@onready var player = $Player
#@onready var control = $CanvasLayer/Control
@onready var ui = $CanvasLayer/UI as UI






var is_dice_menu_open: bool = false




#TODO the last target you clicked on is the enemy you will attack with the button? tweak for vats


func _ready():
	player.connect("player_position",Callable(ui,"print_player_position")) # connects player movement to dialogue window
	player.attack_pattern.attack_area.connect("area_entered",Callable(ui,"update_target_texture"))
	
	player.connect("send_char_sheet_to_hud",Callable(ui,"recieved_char_sheet"))
	player.emit_signal("send_char_sheet_to_hud",player.stats.CharacterSheetData)
	
	
	
	return



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#obtain the mouse position and feed to everything else
	var mouse_pos = get_local_mouse_position()
	var start_pos = tile_map.local_to_map(player.position)
	var end_pos = tile_map.local_to_map(mouse_pos)
	ui.update_grid_coords(mouse_pos,end_pos)
	
	if !is_dice_menu_open:
		path.draw_path(start_pos,end_pos)
		player
	
	else:
		return




