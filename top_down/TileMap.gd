extends TileMap

signal astar_grid_generated(astar_grid)

# default and hover z-index values
var default_z_index_mouse = 0
var hover_z_index = -1


#current cell being hovered
var current_hover_cell = Vector2(-1,-1) #default value

var astar_grid: AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_astar()
	#set_process_unhandled_input(true)
	pass # Replace with function body.

func _unhandled_input(event):
	pass
	#if event is InputEventMouseMotion: #if the mouse moves
		### if the event coords align with grid coords
		#update_hover_tile(event.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_hover_tile(get_global_mouse_position())


func _physics_process(delta):
	pass
	#var mouse_pos = get_viewport().get_mouse_position()
	#var tile_pos = local_to_map(mouse_pos)
	#
	#var tile_data = get_cell_tile_data(0,tile_pos)
	#
	#if tile_data is TileData:
		#print(tile_data.get_custom_data("walkable"))


func update_hover_tile(mouse_pos):
	var cell = local_to_map(to_local(mouse_pos))
	var tile_data = get_cell_tile_data(0,cell)
	if tile_data is TileData:
		pass
		#print(tile_data.get_custom_data("Name"))
		#tile_data.set_z_index(hover_z_index)

func generated_astar_grid() -> void: #sends the astargrid once its done
	astar_grid_generated.emit(astar_grid)
		
func _init_astar(): #initializes the astar grid
	astar_grid = AStarGrid2D.new()
	astar_grid.region = self.get_used_rect() #gets used tiles	
	
	
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	# add obstacles in tilemap. scans from top left to bottom right. adds everything that has walkable == false or no data to the solid block list
	for x in self.get_used_rect().size.x: # gets the size of the tile map
		for y in self.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + self.get_used_rect().position.x, #offset by initial point of the grid
				y + self.get_used_rect().position.y
			)
			var tile_data = self.get_cell_tile_data(0,tile_position)
			
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
	
	generated_astar_grid()

func _add_solid_point_to_Astar_grid(solid_point: Vector2i) -> void: # adds an obstacle to the grid
	astar_grid.set_point_solid(solid_point)
	#print(astar_grid.is_dirty())




func _on_enemy_current_position_grid(current_position): #recieves the enemy position
	_add_solid_point_to_Astar_grid(current_position)

