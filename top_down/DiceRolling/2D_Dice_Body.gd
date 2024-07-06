extends RigidBody2D

class_name dicebody

@export var die_graphic: AnimatedSprite2D
@export var die_number: Sprite2D
@export var dice_roll_animation: AnimationPlayer

@onready var selected_die_gfx = $SelectedDieGfx as Sprite2D


var _dragging: bool = false
var push_force: Vector2 = Vector2.ZERO
var bump_strength: float = 200 #get based on mouse motion?
var bump_damping: float = 0.9
var dice_value: int = 12
var dice_outcome: int = randi_range(1,dice_value)
var offset_position_dice: Vector2 
var vector: Vector2 = Vector2.ZERO
var selected = false:
	set = set_selected


#var DT: int: set = set_DT,
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#dice_roll_animation.play("roll")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if selected:
		_attach_to_mouse_group(delta)
	if _dragging:
		_attach_to_mouse(delta)
	


func _attach_to_mouse_group(delta: float) -> void:
	global_position = lerp(global_position,get_global_mouse_position() + offset_position_dice, 25*delta)
	
	
func _attach_to_mouse(delta: float) -> void:
	global_transform.origin = get_global_mouse_position()
	#position = get_global_mouse_position()


func _on_dice_input_event(_viewport: Node, event: InputEvent, shape_idx:int): #only reads inputs that occur with the area
	#if shape_idx == 0:
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		_dragging = true
	if event is InputEventMouseButton and event.is_action_released("left_click"):
		_dragging = false

#func _input(event) -> void:
	#if event is InputEventMouseButton and event.is_action_released("left_click"): #reads all inputs
		#_dragging = false

#TODO prevent dice from overlapping by pushing them away from each other
#TODO once dice enters A/D area, modulate it red and set its internal setting to A/D
#TODO show particle FX once the dice rolls

func print_my_groups() -> void:
	print(get_groups())
	

func roll_die() -> void:
	dice_roll_animation.play("roll")
	return

func set_die_gfx() -> int:
	dice_outcome = randi_range(1,dice_value)
	die_graphic.set_frame(dice_outcome-1)
	die_number.set_frame(dice_outcome-1)
	return dice_outcome


func set_selected(value) -> void:
	selected = value
	selected_die_gfx.set_visible(selected)


func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "roll":
		print(dice_outcome)







