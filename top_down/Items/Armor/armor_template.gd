extends Item

class_name Armor

signal my_signal

@export var armor_type: String
@export var block_hit_die: int


func trigger_signal():
	return
	emit_signal("my_signal")



