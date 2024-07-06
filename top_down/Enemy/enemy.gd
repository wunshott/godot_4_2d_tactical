extends Node2D
class_name Enemy

signal current_position_grid(current_position: Vector2i)
signal activate_attack_menu()
signal activate_vats_menu()
signal fill_vats_injuries(Injuries) #TODO injuries should be sent to vats as well.
signal send_char_sheet_to_vats(TargetSheetData: CharacterSheet)

#TODO injuries to the stats of a character, sent to the vats when??


@onready var map = $"../TileMap"
@onready var stats = $Stats
@onready var inventory = $Inventory
@onready var area_2d = $Area2D

@export var target_sprite: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var curent_position = map.local_to_map(self.position)
	_send_position_to_astargrid(curent_position)
	stats.populate_character()
	send_char_sheet_to_vats.emit(stats.CharacterSheetData)



# Called every frame. 'delta' is the elapsedg time since the previous frame.
func _process(delta):
	pass


func _send_position_to_astargrid(curent_position):
	#every time the enemy finishes moving, send its position to the astar grid algo and force and update
	current_position_grid.emit(curent_position)




#func _on_area_2d_input_event(viewport, event:InputEvent, shape_idx):
	#if event.is_action_pressed("right_click"):
		#if area_2d.has_overlapping_areas() == true:
			#print(area_2d.get_overlapping_areas())
			#activate_vats_menu.emit()
		#


func _on_ready(): #whent he node is loaded in
	pass



