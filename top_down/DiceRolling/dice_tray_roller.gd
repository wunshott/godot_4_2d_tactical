extends Node2D

class_name DiceTray


@onready var test_battle = $"../../.." as Node2D

@onready var right_area_collision = $Area2D/RightAreaCollision as CollisionShape2D
@onready var attack = $Attack as Area2D #TODO rename as right arm dice?

@onready var left_area_collision = $Area2D/LeftAreaCollision as CollisionShape2D
@onready var defense = $Defense as Area2D #TODO rename as left arm dice?

@onready var selection_box = $SelectionBox as Area2D
@onready var selection_box_shape = $SelectionBox/SelectionBoxShape as CollisionShape2D

@onready var label = $Label
@onready var reset_dice_button = $ResetDiceButton as Button




var is_mouse_dragging: bool = false #tracks if the mouse if dragging
var selected_dice: Array = [] # holds the array of selected units
var drag_start: Vector2 # tracks the lcoation of where the select rectnagel starts
var select_rect: RectangleShape2D = RectangleShape2D.new() # collision shape for drag box
var mouse_offset: Vector2
var dragging_dice: bool = false

var is_visible: bool = false

var starting_dice_positions: Array[Vector2]


@export var dice_roller_tray_left: left_area: set = set_dice_roller_tray_left
@export var dice_roller_tray_right: right_area:set = set_dice_roller_tray_right

#TODO need to tie a signal to window dice changing for the dice and area movement OR have a set size when dice are rolled
#TODO have the dice sparkle when highlighted with square
#TODO exclude things that aren't dice from being selected by box
#TODO update dice to have sprite and roll abilities of previous dice
#TODO add the reset button to move all dice backt to their o riginal position
#TODO make a set window for dice roll (witcher roll box)

enum left_area {
	LARGE, # dialogue closed
	MED, # dialogue medium
	SMALL, #dialogue large
}

enum right_area {
	LARGE, # char menu
	SMALL, # char menu
}

func _ready():
	selection_box_shape.shape.size = Vector2.ZERO
	selection_box.monitoring = false
	for idx: RigidDice in get_tree().get_nodes_in_group("dice"):
		reset_dice_button.connect("pressed",Callable(idx,"reset_starting_dice_position"))


func get_starting_dice_position():
	get_tree().call_group("dice", "save_position")
	#TODO update to put dice in the *real* position



	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_mouse_dragging:
		queue_redraw()
	label.set_text(str(get_global_mouse_position()))
	if dragging_dice:
		queue_redraw()
	
	
	
func _physics_process(delta):
	if dragging_dice:
		check_boundaries()
#func _draw() -> void:
	#if is_mouse_dragging:
		#draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
			#Color.YELLOW, false, 2.0)

func _draw() -> void:
	if is_mouse_dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color(1, 1, 1, 0.3), false)
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color(1, 1, 1, 0.3), true)
	


func _on_button_pressed():
	#rolls dice
	get_tree().call_group("Attack","roll_die")
	get_tree().call_group("Defense","roll_die")

#TODO assign the areas to groups and have the groups move in sync?
#TODO is there a cleaner solution to position the UI besides more states? change the ratio?

func set_dice_roller_tray_left(value:left_area) -> void:
	dice_roller_tray_left = value
	if dice_roller_tray_left == left_area.LARGE:
		left_area_collision.position.x = 18
		defense.position.x = 57
	if dice_roller_tray_left == left_area.MED:
		left_area_collision.position.x = 176
		defense.position.x = 211
	if dice_roller_tray_left == left_area.SMALL:
		left_area_collision.position.x = 244
		defense.position.x = 283

func set_dice_roller_tray_right(value:right_area) -> void:
	dice_roller_tray_right = value
	if dice_roller_tray_right == right_area.LARGE:
		right_area_collision.position.x = 450
		attack.position.x = 413
	if dice_roller_tray_right == right_area.SMALL:
		right_area_collision.position.x = 592
		attack.position.x = 561

func toggle_dice_menu() -> void:
	is_visible = !is_visible
	var tween = get_tree().create_tween()
	
	if is_visible:
		set_visible(is_visible)
		tween.tween_property(self, "position",Vector2(0,0),.1).set_ease(Tween.EASE_IN_OUT)
		test_battle.is_dice_menu_open = true
	else:
		test_battle.is_dice_menu_open = false
		tween.tween_property(self, "position",Vector2(0,-293),.1).set_ease(Tween.EASE_IN_OUT)
	return
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action("left_click"):
		if event.pressed:
			is_mouse_dragging = true
			drag_start = event.position
			#print_debug(drag_start)
			selection_box.global_position = drag_start
			#selection_box_shape.global_position = drag_start
			selection_box_shape.shape.extents = Vector2.ZERO
			selection_box.monitoring = true
		
		else:
			is_mouse_dragging = false
			selected_dice = selection_box.get_overlapping_bodies()
			if selected_dice.size() > 1: #TODO breaks when you allow selecting 1 with the box
				for idx: RigidDice in selected_dice:  #turn on the selector box
					idx.set_selected(true)
				dragging_dice = true
				mouse_offset = get_global_mouse_position() - selection_box.global_position
			
			else:
				dragging_dice = false
				for idx:RigidDice in get_tree().get_nodes_in_group("dice"):
					idx.set_selected(false)

			
			selection_box.monitoring = false
	
	if event is InputEventMouseMotion:
		if is_mouse_dragging:
			update_selection_box(event.position)
		elif dragging_dice:
			move_selected_dice(event)


func update_selection_box(current_position: Vector2) -> void:

	var size = current_position - drag_start
	selection_box_shape.shape.extents = Vector2(abs(size.x),abs(size.y)) /2.0
	var box_position = drag_start + size /2.0
	selection_box.global_position = box_position
	
	
	
func move_selected_dice(event: InputEvent) -> void:
	var target_pos = get_global_mouse_position() - mouse_offset
	var displacement = target_pos - selection_box.global_position


		
	for idx in selected_dice:
		if idx is RigidBody2D:
			#var new_pos = idx.global_position + displacement
			
			#var clamped_displacement = new_pos - idx.global_position
			idx.apply_central_impulse(displacement * idx.mass * 5)
			
	selection_box.global_position += displacement
	mouse_offset = get_global_mouse_position() - selection_box.global_position

func check_boundaries():
	var min_x = 16
	var min_y = 16
	var max_x = 500
	var max_y = 349
	
	for idx in selected_dice:
		if idx is RigidBody2D:
			var pos = idx.global_position
			var stopped = false
		# Check left boundary
			if pos.x < min_x:
				pos.x = min_x
				stopped = true

			# Check right boundary
			if pos.x > max_x:
				pos.x = max_x
				stopped = true

			# Check top boundary
			if pos.y <min_y:
				pos.y = min_y
				stopped = true

			# Check bottom boundary
			if pos.y > max_y:
				pos.y = max_y
				stopped = true

			# If the dice hit a boundary, stop it
			if stopped:
				idx.linear_velocity = Vector2.ZERO
				idx.angular_velocity = 0
				idx.global_position = pos

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area is dice:
		area.selected = false
		area._dragging = false




