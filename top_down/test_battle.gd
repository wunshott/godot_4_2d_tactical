extends Node2D

@onready var path = $Path
@onready var tile_map = $TileMap
@onready var hud = $CanvasLayer/HUD
@onready var player = $Player
@onready var button = $Button

@onready var character_sheet: CharacterSheetHUD = $CanvasLayer/HUD2/CharacterSheet


#TODO the last target you clicked on is the enemy you will attack with the button? tweak for vats



<<<<<<< Updated upstream
=======

var is_dice_menu_open: bool = false



#TODO character creation
#TODO death call system and menu
#TODO estate planning menu
#TODO dice roller speaking to dialogue menu, it speaks techincally
#TODO combat scene (have the ability to place allies around), turn based combat
#1. battle splash
#2. allow player to place party
#3. allow player to start battle
#4. show battle actions
#5. introduce turn order and end turn button
#6. on player's turn, allow them to move character and do actions (stamina cost)
#7. allow enemies to move, attack, end turn. their attack's should prompt player for an action


>>>>>>> Stashed changes
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




