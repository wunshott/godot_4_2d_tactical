extends Control

class_name HPDTBar

@onready var skull:Sprite2D = $Skull
@onready var dt_bar: TextureProgressBar = $DTBar
@onready var hp_bar: TextureProgressBar = $HPBar


# Called when the node enters the scene tree for the first time.
func _ready():
	skull.position = Vector2(dt_bar.get_rect().size.x*dt_bar.get_value(), dt_bar.get_rect().size.y/3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dt_bar_value_changed(value):

	var progress_ratio = value / dt_bar.get_max()
	var bar_width = dt_bar.get_rect().size.x
	var skull_position = Vector2(bar_width*progress_ratio, dt_bar.get_rect().size.y/3)
	
	
	skull.position = skull_position


