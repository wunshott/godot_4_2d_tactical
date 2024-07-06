extends Node2D

class_name DiceTray


@onready var test_battle = $"../../.." as Node2D

@onready var right_area_collision = $Area2D/RightAreaCollision as CollisionShape2D
@onready var attack = $Attack as Area2D #TODO rename as right arm dice?

@onready var left_area_collision = $Area2D/LeftAreaCollision as CollisionShape2D
@onready var defense = $Defense as Area2D #TODO rename as left arm dice?

var is_mouse_dragging: bool = false #tracks if the mouse if dragging
var selected_dice: Array = [] # holds the array of selected units
var drag_start: Vector2 = Vector2.ZERO # tracks the lcoation of where the select rectnagel starts
var select_rect: RectangleShape2D = RectangleShape2D.new() # collision shape for drag box

var is_visible: bool = false



@export var dice_roller_tray_left: left_area: set = set_dice_roller_tray_left
@export var dice_roller_tray_right: right_area:set = set_dice_roller_tray_right

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
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
		tween.tween_property(self, "position",Vector2(0,0),1)
		test_battle.is_dice_menu_open = true
	else:
		test_battle.is_dice_menu_open = false
		tween.tween_property(self, "position",Vector2(0,-293),1)
	return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action("left_click"):
		if event.pressed:
			# if the mouse was clicked and nothing is selected, start dragging
			if selected_dice.size() == 0:
				is_mouse_dragging = true
				drag_start = event.position
				
			#if mouse is clicked and there is selected dice, allow the dice to be moved.
			#clicking on dice should allow the user to move the dice
			#clicking on background unselects the dice
			else:
				for item in selected_dice:
					if item.collider is dice:
						item.collider.selected = false
				selected_dice = []
		
		
		#if mouse is dragging, allow user to highlight dice
		elif is_mouse_dragging:
			is_mouse_dragging = false
			queue_redraw()
			var drag_end: Vector2 = event.position
			select_rect.extents = abs(drag_end - drag_start) / 2 #extends of a shape are measured from the center
			
			var space = get_world_2d().direct_space_state
			var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
			query.collide_with_areas = true
			query.shape = select_rect
			query.transform = Transform2D(0,(drag_end + drag_start) / 2)
			selected_dice = space.intersect_shape(query)
			#get a reference to the physics shape
			#set up a shape the size of the selected window. center of the dragged area is the origin
			#equery the shape physics
			# selected_dice pritns out an array of dicts
			#each dit has a reference to the selected dice. set each of these to selected
			for item in selected_dice:
				if item.collider is dice:
					item.collider.selected = true
					item.collider_group_dragging = true
					item.collider.offset_position_dice = item.collider.position - get_global_mouse_position()

			
			
			
	if event is InputEventMouseMotion and is_mouse_dragging:
		queue_redraw()

#when button is released, query the physics and find units inside the box

func _draw() -> void:
	if is_mouse_dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
			Color.YELLOW, false, 2.0)



func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area is dice:
		area.selected = false
		area._dragging = false
