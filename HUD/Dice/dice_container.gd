extends PanelContainer

class_name DieContainer

signal send_dice_outcome(dice_roll:int)
@export var dice_number: int #TODO clamp?


@onready var dice_roll: Sprite2D = $DiceRoll # spinning dice 
@onready var dice: Sprite2D = $Dice # original dice value
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var number_rolled: Sprite2D = $NumberRolled


var dice_outcome: int 


# Called when the node enters the scene tree for the first time.
func _ready():
	dice.set_visible(true)
	dice_roll.set_visible(false)
	update_dice_graphic(dice,dice_number)
	animation_player.play("entering")
	

func roll_dice() -> void:
	animation_player.play("rolling")
	

func get_dice_outcome() -> void:
	dice_outcome = randi_range(1,dice_number) #rolls the dice
	send_dice_outcome.emit(dice_outcome) #send the dice outcome to the top level array to hold it
	
	update_dice_graphic(dice,dice_outcome)
	
	number_rolled.set_frame(dice_outcome-1)
	animation_player.play("show_dice_outcome")
	
	

	

func update_dice_graphic(dice_input: Sprite2D, face_index:int) -> void:
	var new_texture: Texture2D = dice_input.texture.duplicate(true)
	dice_input.set_texture(new_texture)
	dice_input.texture.set_region((Rect2((face_index -1)*16,0,16,16)))
	#default: Rect2(0, 0, 0, 0)

func _get_drag_data(_at_position: Vector2):
	set_drag_preview(get_preview(dice.get_texture()))
	return self


func get_preview(item_dragged_texture: Texture2D):
	var preview_texture_node = TextureRect.new()
	item_dragged_texture.set_region(Rect2((dice_number- 1)*16,0,16,16))
	preview_texture_node.texture = item_dragged_texture
	preview_texture_node.expand_mode = 1
	preview_texture_node.size = Vector2(48,48)
	
	var preview = Control.new()
	preview.add_child(preview_texture_node)
	return preview
