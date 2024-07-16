extends Node2D
class_name Character

signal send_path(waypoints)
signal movement_ended
signal player_position(position: Vector2)
signal send_char_sheet_to_hud(CharacterSheetData: CharacterSheet)

var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool
var current_point_path: PackedVector2Array
var astar_grid: AStarGrid2D
var exertion_astar_grid: AStarGrid2D

var allowed_path_tile_sprite: Sprite2D



const ALLOWED_PATH_TILE = preload("res://top_down/allowed_path_tile.tscn")
const EXERTION_ALLOWED_PATH_TILE = preload("res://top_down/exertion_allowed_path_tile.tscn")

@onready var map = $"../TileMap" # get this information from a signal. once the sprite spawns in.
@onready var stats: Stats = $Stats
@onready var attack_pattern = $AttackPattern as AttackPattern
@onready var inventory = $Inventory
@onready var test_battle = $".."

@onready var camera_2d = $Camera2D


#TODO separate AC and dodge
#based on perks and stats.
#roll to hit AC goes first.
#if the AC hits, dodge chance is rolled.
#if dodge is successful, hit misses
#if the dodge fails, the hit misses

#TODO lose AC bonus from coordination if you have no weapon

@export var pixels_per_frame: float = 1 #
##@export var text_max_movement: int = 100
#

	
# Called when the node enters the scene tree for the first time.
func _ready():
	#connect signals
	
	
	stats.populate_character() # must be called here, calling it in the script causes an error. the variable doesn't load in
	if !map:
		return
	#get_reachable_tiles(map.local_to_map(self.position), stats._get_movement_pool())
	#_highlight_moveable_tiles()
	#print("Farquad's speed is " + str(stats.speed) + " tiles")
	#print("Farquad's movement exertion rate is " + str(stats.movement_exertion_cost))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _unhandled_input(event):
	
	if event.is_action_pressed("left_click") == false:
		return
	
	if test_battle.is_dice_menu_open:
		return

	var id_path
	 # remove the tiles after moving. need to change to only does this while the tile is moving. does this on mouse clicks
	
	if is_moving: #IF MOVING, starting point for the next path is destination
		
		id_path = astar_grid.get_id_path(# makes path from curent spot to clicked spot
			map.local_to_map(target_position), # gets the player's location
			map.local_to_map(get_global_mouse_position())).slice(1) #ignores the first element
		
	else:# if not moving, current position is starting position
		
		id_path = astar_grid.get_id_path(# makes path from curent spot to clicked spot
			map.local_to_map(global_position), # gets the player's location
			map.local_to_map(get_global_mouse_position())).slice(1) #ignores the first element

	if id_path.is_empty() == false: #if the path is not empty, set the current path to the id path
		
		_remove_highlighted_tiles()
		
		current_id_path = id_path
		current_point_path = astar_grid.get_point_path(
			map.local_to_map(target_position),
			map.local_to_map(get_global_mouse_position())
		)
		
		for i in current_point_path.size():
			current_point_path[i] = current_point_path[i] + Vector2(8,8) #offsets the line drawn to be centered on the grid
		
		send_path.emit(current_point_path)
	#add WASD movement
	# add ray for collision
	# add ui

func _physics_process(delta):
	_move_token_no_combat(delta)
	
	

func _move_token_no_combat(delta) -> void:
	if current_id_path.is_empty(): # if there is target position, stop moving
		return
	
	if is_moving == false:
		target_position = map.map_to_local(current_id_path.front()) #sets the destination = first element in thearray
		is_moving = true # set moving to be true
	
	global_position = global_position.move_toward(target_position,pixels_per_frame) #moves token to the target
	
	if global_position == target_position: #if you've arrived at the target location
		current_id_path.pop_front() # removes the first item of the array
		
		if current_id_path.is_empty() == false: #if you still have movement, allow more movement
			target_position = map.map_to_local(current_id_path.front())
		else:
			is_moving = false
			player_position.emit(global_position)
			#print("your current coordinate is ", map.local_to_map(self.position))

func _move_token(delta):
	if current_id_path.is_empty(): # if there is target position, stop moving
		return
	
	#add a line that checks if the length of current_id_path is lower than the available movement
	#subtract one movement after you arrive at the location
	#add a button to refresh movement points
	var total_exertion_tiles = stats.CharacterSheetData.get_stamina()/stats.movement_exertion_cost
	
	if is_moving == false and stats._get_movement_pool() >= current_id_path.size(): #if you are not moving, set a target
		target_position = map.map_to_local(current_id_path.front()) # gets the first element in the array
		is_moving = true # set moving to be true
	
	#if you want to move and you have stamina
	elif is_moving == false and stats._get_movement_pool() < current_id_path.size() and total_exertion_tiles + stats._get_movement_pool() >= current_id_path.size():
		stats._change_stamina_from_moving((current_id_path.size() - stats._get_movement_pool())*stats.movement_exertion_cost) #subtract stamina by extra_tiles_moved = path - movement_pool
		target_position = map.map_to_local(current_id_path.front()) # gets the first element in the array
		is_moving = true # set moving to be true
	
	#if you want to move and have no stamina
	elif  is_moving == false and stats._get_movement_pool() < current_id_path.size():
		print("you can't move anymore this turn, add a tween to the sprite for feedback")
		current_id_path.clear()
		return #go back to the start
		
	global_position = global_position.move_toward(target_position,pixels_per_frame) #moves token to the target
	if global_position == target_position: #if you've arrived at the target location
		current_id_path.pop_front() # removes the first item of the array
		stats._set_movement_pool(stats._get_movement_pool()-1) #remove 1 from the movement pool to represent the token moved
		
		if current_id_path.is_empty() == false: #if you still have movement, allow more movement
			target_position = map.map_to_local(current_id_path.front())
		else:
			is_moving = false
			#print("your current coordinate is ", map.local_to_map(self.position))
			movement_ended.emit()


func get_reachable_tiles(start_pos, max_range): 
	var allowed_path_tile_stack: Array
	var exertion_path_tile_stack: Array
	_remove_highlighted_tiles()
	
	for cell_position in map.get_used_cells(0): #for every cell on this layer
		var current_grid_path = astar_grid.get_id_path(start_pos,cell_position).slice(1).size()
		if current_grid_path <= max_range and current_grid_path > 0: # if the manhat cost is <= the current movement pool,using slice to remove the first element cause its the player's tile
			#get_id_path returns 0 if there is an obstacle
			allowed_path_tile_stack.append(cell_position)
		elif current_grid_path > max_range and current_grid_path <= max_range + stats.Stamina/stats.movement_exertion_cost:
			#if the path is longer than the max range and its within the max_range + bonus tiles
			exertion_path_tile_stack.append(cell_position)
	#print(allowed_path_tile_stack)
	#print(astar_grid.get_id_path(start_pos,Vector2(5,3)).size() )
	
	for coord in allowed_path_tile_stack: # displays tiles you can move to
		allowed_path_tile_sprite = ALLOWED_PATH_TILE.instantiate() #makes a new node using the sprite
		allowed_path_tile_sprite.position += (map.map_to_local(coord) - self.position) # sets the position of the node to be on the cell. converts from grid to local cords
		add_child(allowed_path_tile_sprite)
	
	for coord in exertion_path_tile_stack: # displays the exertion tiles
		allowed_path_tile_sprite = EXERTION_ALLOWED_PATH_TILE.instantiate() #makes a new node using the sprite
		allowed_path_tile_sprite.position += (map.map_to_local(coord) - self.position) # sets the position of the node to be on the cell. converts from grid to local cords
		add_child(allowed_path_tile_sprite)
		



			
func _on_tile_map_astar_grid_generated(generated_astar_grid):
	astar_grid = generated_astar_grid



func _on_movement_ended():
	get_reachable_tiles(map.local_to_map(self.position), stats._get_movement_pool())
	return
	#_highlight_moveable_tiles()
	 # Replace with function body.




func _on_hud_end_turn_button_pressed(): #reset movement points
	stats._set_movement_pool(stats.speed) #= clampi(speed,0,text_max_movement)
	get_reachable_tiles(map.local_to_map(self.position), stats._get_movement_pool())
	#_highlight_moveable_tiles()


func _remove_highlighted_tiles() -> void:
	for child in get_children(): #remove all the previous tiles before generating new tiles
		if child is PathTile:
			child.queue_free()




