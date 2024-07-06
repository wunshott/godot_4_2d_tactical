extends Control

class_name HPDTBar

@onready var skull:Sprite2D = $Skull
@onready var dt_bar: TextureProgressBar = $DTBar
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var dt_label = $"../DTLabel" as Label
@onready var hp_label = $"../HPLabel" as Label



# Called when the node enters the scene tree for the first time.
func _ready():
	skull.position = Vector2(dt_bar.get_rect().size.x*dt_bar.get_value(), dt_bar.get_rect().size.y/3)
	



func _on_dt_bar_value_changed(value):

	var progress_ratio = value / dt_bar.get_max()
	var bar_width = dt_bar.get_rect().size.x
	var skull_position = Vector2(bar_width*progress_ratio, dt_bar.get_rect().size.y/3)
	
	
	skull.position = skull_position


## HP/DT Updating Functions
func on_stats_set_max_HP(value: int) -> void:
	#hp.set_text("HP: " + str(value))
	hp_bar.set_max(value)
	dt_bar.set_max(value)


func on_stats_set_HP(value: int) -> void:
	#hp.set_text("HP: " + str(value))
	hp_bar.set_value(value)
	hp_label.set_text("HP: " + str(value) )

func on_stats_set_DT(value: int):
	dt_bar.set_value(value)
	dt_label.set_text("DT: " + str(value))
