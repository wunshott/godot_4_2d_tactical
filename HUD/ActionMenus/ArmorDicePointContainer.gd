extends VBoxContainer

class_name ArmorDicePointContainer



@export var IncreaseDieButton: TextureButton
@export var DecreaseDieButton: TextureButton

@export var dice_container: DieContainer

@onready var armor_roller_menu = $"../../../../.."



const DICE_CONTAINER = preload("res://HUD/Dice/dice_container.tscn")

func _ready():
	#buttons start disabled. enabled once the player commits to an actions. then disabled again
	toggle_armor_buttons(false)
	for children in get_children(): #clear out dice in editor
		if children is DieContainer:
			children.queue_free()
	create_die()
	#dice_container.roll_die()


func _on_increase_die_button_pressed():
	if armor_roller_menu.get_armor_points() == 0:
		dice_container.animation_player.play("decline_shake")
		return
	dice_container.increase_die_number()
	
	


func create_die(mob_dice_outcome: int = 6) -> void:
	dice_container = DICE_CONTAINER.instantiate()
	dice_container.set_h_size_flags(4)
	dice_container.dice_outcome = mob_dice_outcome
	IncreaseDieButton.add_sibling(dice_container)
	
	#print_debug(dice_container.dice_max)
	
	
func toggle_armor_buttons(value: bool) -> void:
	IncreaseDieButton.set_disabled(!value)
	DecreaseDieButton.set_disabled(!value)

func _on_decrease_die_button_pressed():
	if armor_roller_menu.get_armor_points() == 0:
		dice_container.animation_player.play("decline_shake") #player will need to reset
		return
	dice_container.decrease_die_number()
	#print_debug(armor_roller_menu.get_armor_points())


