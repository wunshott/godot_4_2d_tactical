extends Node2D

@onready var path = $Path
@onready var tile_map = $TileMap
@onready var hud = $CanvasLayer/HUD
@onready var player = $Player
@onready var button = $Button

@onready var character_sheet: CharacterSheetHUD = $CanvasLayer/HUD2/CharacterSheet


#TODO the last target you clicked on is the enemy you will attack with the button? tweak for vats



func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#obtain the mouse position and feed to everything else
	var mouse_pos = get_local_mouse_position()
	var start_pos = tile_map.local_to_map(player.position)
	var end_pos = tile_map.local_to_map(mouse_pos)
	
	hud.grid_cords = end_pos
	hud.pixel_cords = mouse_pos


	path.draw_path(start_pos,end_pos)




