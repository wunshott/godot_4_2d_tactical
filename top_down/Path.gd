extends Line2D



@onready var player_stats = $"../Player/Stats"
@onready var tile_map = $"../TileMap"

@onready var movement_reticle = $Movement_Reticle


var astar_grid: AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#_init_astar()


	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var mouse_pos = get_local_mouse_position()
	#var start_pos = tile_map.local_to_map(player.position)
	#var end_pos = tile_map.local_to_map(mouse_pos)
	
	
	#if astar_grid.is_in_boundsv(end_pos) == false: #checks if the mouse is within the grid
		#return
	#
	#
	#draw_path(start_pos,end_pos)
	pass

func draw_path(start,end):
	if astar_grid.is_in_boundsv(end) == false: #checks if the mouse is within the grid
		return
	self.clear_points()
	var waypoint = find_path(start,end)
	for tile in waypoint:
		self.add_point(tile_map.map_to_local(tile))

func draw_path_combat(start,end):
	if astar_grid.is_in_boundsv(end) == false: #checks if the mouse is within the grid
		return
	self.clear_points()
	var char_exertion_range = player_stats._get_movement_pool() + player_stats.CharacterSheetData.get_stamina()/player_stats.movement_exertion_cost
	#allows the marker to be placed only within movementpool
	if astar_grid.get_id_path(start,end).slice(1).size() <= player_stats._get_movement_pool() and astar_grid.get_id_path(start,end).slice(1).size() > 0:
		var waypoint = find_path(start,end)
		for tile in waypoint:
			self.add_point(tile_map.map_to_local(tile))
	
	elif astar_grid.get_id_path(start,end).slice(1).size() > player_stats._get_movement_pool() and astar_grid.get_id_path(start,end).slice(1).size() <= char_exertion_range:
		#var exertion_tiles_traveled = astar_grid.get_id_path(start,end).slice(1).size() - player.movement_pool
		var waypoint = find_path(start,end)
		for tile in waypoint:
			self.add_point(tile_map.map_to_local(tile))

		
func find_path(start,end):
	var id_path = []
	id_path = astar_grid.get_id_path(# makes path from curent spot to clicked spot
			start, # gets the player's location
			end).slice(1)
			
	
	movement_reticle.position = tile_map.map_to_local(end)
	return id_path




func _on_tile_map_astar_grid_generated(latest_astar_grid):
	astar_grid = latest_astar_grid
