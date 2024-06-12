extends Node2D

@onready var path = $Path
@onready var tile_map = $TileMap
@onready var hud = $CanvasLayer/HUD
@onready var player = $Player
@onready var button = $Button

signal tree_loaded

@export var test_resource: Armor

## Called when the node enters the scene tree for the first time.
func _ready():
	tree_loaded.emit()
	test_resource.connect("my_signal",Callable(self,"_on_my_signal")) # resource file emits signals
	test_resource.trigger_signal()
	button.pressed.connect(test_resource.test_function) # resource file can do functions based on signal
	#TODO make an event bus that emits signal to multiple nodes?
	#TODO enemy and player should share a vats menu
	#TODO signals should connect via resources when possible
	#TODO remove stamina damage. add as an option to some attacks
	#TODO add health bars to limbs
	#TODO remove pips
	#TODO add death threshold
	#TODO add limb hp bar combination
	#TODO revamp attack menu -> SKALD action bar
	
	
	pass # Replace with function body

func _on_my_signal() -> void:
	print("Signal emitted from resource!")
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#obtain the mouse position and feed to everything else
	var mouse_pos = get_local_mouse_position()
	var start_pos = tile_map.local_to_map(player.position)
	var end_pos = tile_map.local_to_map(mouse_pos)
	
	hud.grid_cords = end_pos
	hud.pixel_cords = mouse_pos


	path.draw_path(start_pos,end_pos)

func _input(event):
	if event.is_action_pressed("attack_menu") == true:
		set_visible(true)



