extends PanelContainer

class_name DieContainer

@export var Die: int
@onready var texture_rect = $TextureRect
@onready var dice = $Dice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_dice_graphic(face_index:int) -> void:
	dice.frame = face_index
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _get_drag_data(at_position: Vector2):
	#return Die #return the dice value
#
#func _can_drop_data(at_position: Vector2, data) -> bool:
	#return data is int 
#
#func _drop_data(at_position: Vector2, data): 
	#if data:
		#Die = data
		#update_dice_graphic(Die)
	#return

#func get_preview(item_dragged_texture: Texture2D):
	#return preview
