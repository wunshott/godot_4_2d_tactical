extends VBoxContainer

class_name ActionLineItem

signal placeholder_attack(number_of_bonus_dice: int)

@onready var label = $Label
@onready var button = $Button

@export var CharacterSheetData: CharacterSheet

var weapon_bonus_hit_dice: int

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("placeholder_attack",Callable(Dice_Roller,"load_in_attack"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	weapon_bonus_hit_dice = CharacterSheetData.equipped_weapon_dictionary["right_arm"].weapon_hit_die_amount
	roll_to_attack()

func roll_to_attack() -> void:
	var limb_hit_die: int = CharacterSheetData.get_limb_hp("right_arm")
	var total_die_to_send: int = weapon_bonus_hit_dice + limb_hit_die
	placeholder_attack.emit(total_die_to_send)
